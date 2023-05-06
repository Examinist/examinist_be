class Exam < ApplicationRecord

  # constants
  NEXT_VALID_TRANSITIONS = { unscheduled: %i[scheduled], scheduled: %i[unscheduled ongoing], ongoing: %i[pending_grading],
                             pending_grading: %i[graded] }.freeze

  # enums
  enum status: { unscheduled: 0, scheduled: 1, ongoing: 2, pending_grading: 3, graded: 4}, _default: 'unscheduled'

  # validations
  validates_presence_of :title, :course, :staff, :duration
  with_options on: :update do
    validate :validate_state_transition, if: :will_save_change_to_status?
  end

  # Associations
  belongs_to :course
  belongs_to :staff
  has_many :exam_questions, dependent: :destroy
  has_many :questions, through: :exam_questions
  
  # Nested Attributes
  accepts_nested_attributes_for :exam_questions, allow_destroy: true

  # scopes
  scope :filter_by_status, ->(status) { where(status: status) }

  # Hooks
  before_create :check_if_can_create
  before_update :raise_error, unless: ->{ will_save_change_to_status? || %w[unscheduled scheduled].include?(status_was) }
  before_destroy :raise_error, unless: -> { unscheduled? }
  after_save :calculate_total_score, unless: ->{ is_auto }
  after_update_commit :update_exam_status, if: :saved_change_to_starts_at?
  after_update_commit :end_exam, if: :saved_change_to_duration

  # Methods
  def valid_status_transition?(old_status, new_status)
    NEXT_VALID_TRANSITIONS[old_status.to_sym]&.include?(new_status.to_sym)
  end

  private

  def validate_state_transition
    return if valid_status_transition?(status_was, status)

    errors.add(:status, :invalid_status_transition, from: status_was, to: status)
  end

  def calculate_total_score
    update_column(:total_score, exam_questions.sum(:score))
  end

  def raise_error
    locale_path = changed? ? 'exam.cant_update' : 'exam.cant_delete'
    raise(ErrorHandler::GeneralRequestError, I18n.t(locale_path))
  end

  def check_if_can_create
    return if staff.assigned_courses.include? course

    raise(ErrorHandler::GeneralRequestError, I18n.t('exam.cant_create'))
  end

  def update_exam_status
    start_exam
    end_exam
  end

  def start_exam
    UpdateExamStatusJob.set(wait_until: self.starts_at).perform_later({ exam_id: id,
                                                                   starts_at: self.starts_at,
                                                                   operation: 'start_exam' })
  end

  def end_exam
    ends_at = starts_at + duration.minutes
    UpdateExamStatusJob.set(wait_until: ends_at).perform_later({ exam_id: id,
                                                                 ends_at: ends_at,
                                                                 operation: 'end_exam' })
  end
end

# == Schema Information
#
# Table name: exams
#
#  id          :bigint           not null, primary key
#  duration    :integer
#  has_models  :boolean          default(FALSE)
#  is_auto     :boolean          default(FALSE)
#  starts_at   :datetime
#  status      :integer
#  title       :string
#  total_score :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :bigint           not null
#  staff_id    :bigint           not null
#
# Indexes
#
#  index_exams_on_course_id  (course_id)
#  index_exams_on_staff_id   (staff_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (staff_id => staffs.id)
#
