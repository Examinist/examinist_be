# frozen_string_literal: true

# Represents a student's exam.
class StudentExam < ApplicationRecord
  # constants
  NEXT_VALID_TRANSITIONS = { upcoming: %i[ongoing], ongoing: %i[pending_grading], pending_grading: %i[graded] }.freeze

  # enums
  enum status: { upcoming: 0, ongoing: 1, pending_grading: 2, graded: 3 }, _default: 'upcoming'

  # validations
  validates_presence_of :exam
  with_options if: :student_id do
    validates :student, uniqueness: { scope: :exam, message: I18n.t('activerecord.errors.duplicated',
                                                                    model_name: 'Student Exam') }
  end
  validates :grade, numericality: { greater_than_or_equal_to: 0.0 }, if: -> { grade.present? }
  with_options on: :update do
    validate :validate_state_transition, if: :will_save_change_to_status?
  end

  # Associations
  belongs_to :student, optional: true
  belongs_to :exam
  has_many :student_answers, dependent: :destroy
  has_many :exam_questions, through: :student_answers

  # Nested Attributes
  accepts_nested_attributes_for :student_answers

  # Scopes
  scope :sixty_minutes, lambda { 
    joins(:exam)
    .where('exams.starts_at <= :date', date: Time.now + 60.minutes) 
    .where('exams.ends_at >= :current_date', current_date: Time.now)
  }
  scope :filter_by_status, ->(status) { where(status: status) }

  # Hooks
  before_update :raise_error, unless: -> { will_save_change_to_status? || %w[ongoing pending_grading].include?(status_was) }
  before_update :check_final_submission
  after_update_commit :check_parent_exam_completion, if: -> { graded? }

  # Non DB attributes
  attr_accessor :is_submitting

  # Methods
  def valid_status_transition?(old_status, new_status)
    NEXT_VALID_TRANSITIONS[old_status.to_sym]&.include?(new_status.to_sym)
  end

  def assigned_busy_lab
    all_students = exam.students.sort_by { |student| student.academic_id }
    index = all_students.find_index { |student| student.id == student_id }
    available_busy_labs = exam.busy_labs.sort_by { |busy_lab| busy_lab.id }
    sum = 0
    available_busy_labs.each do |bl|
      return bl if (index + 1) <= (bl.lab.capacity + sum)

      sum += bl.lab.capacity
    end
    available_busy_labs.last
  end

  def student_status
    return 'Attended' if grade.present?

    'Absent'
  end

  def partial_graded_questions
    student_answers.where.not(score: nil).size
  end

  def partial_score
    student_answers.sum(:score)
  end

  def total_score
    exam_questions.sum(:score)
  end

  private

  def validate_state_transition
    return if valid_status_transition?(status_was, status)

    errors.add(:status, :invalid_status_transition, from: status_was, to: status)
  end

  def raise_error
    raise(ErrorHandler::GeneralRequestError, I18n.t('student_exam.cant_update'))
  end

  def check_final_submission
    self.status = :pending_grading if @is_submitting
    # TODO: Activate the grading process
  end

  def check_parent_exam_completion
    student_exams_except_current = exam.student_exams.where.not(id: id)
    return unless student_exams_except_current.all? { |student_exam| student_exam.status == 'graded' }

    exam.update!(status: :graded)
  end
end

# == Schema Information
#
# Table name: student_exams
#
#  id         :bigint           not null, primary key
#  grade      :float
#  status     :integer          default("upcoming")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  exam_id    :bigint           not null
#  student_id :bigint
#
# Indexes
#
#  index_student_exams_on_exam_id     (exam_id)
#  index_student_exams_on_student_id  (student_id)
#
# Foreign Keys
#
#  fk_rails_...  (exam_id => exams.id)
#  fk_rails_...  (student_id => students.id)
#
