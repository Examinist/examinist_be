class Exam < ApplicationRecord

  # constants
  NEXT_VALID_TRANSITIONS = { unscheduled: %i[scheduled], scheduled: %i[unscheduled ongoing], ongoing: %i[pending_grading graded],
                             pending_grading: %i[graded] }.freeze

  DIFFICULTIES = %w[easy medium hard].freeze
  UNSCHEDULED = 'unscheduled'.freeze
  SCHEDULED = 'scheduled'.freeze

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
  belongs_to :schedule, optional: true
  has_many :exam_questions, dependent: :destroy
  has_many :questions, through: :exam_questions
  has_many :busy_labs, dependent: :destroy
  has_many :labs, through: :busy_labs
  has_many :students, through: :course
  has_many :student_exams, dependent: :destroy

  # Nested Attributes
  accepts_nested_attributes_for :exam_questions, allow_destroy: true
  accepts_nested_attributes_for :busy_labs, allow_destroy: true

  # scopes
  scope :filter_by_status, ->(status) { where(status: status) }

  # Hooks
  before_validation :add_ends_at!, if: -> { will_save_change_to_starts_at? && starts_at.present? }
  before_create :check_if_can_create
  before_update :raise_error, unless: ->{ will_save_change_to_status? || %w[unscheduled scheduled].include?(status_was) }
  before_update :nullify_scheduling_attributes!, if: ->{ will_save_change_to_status?(to: UNSCHEDULED) }
  before_update :update_exam_status_scheduled, if: -> { will_save_change_to_starts_at?(from: nil) }
  before_update :check_starts_at_validty, if: -> { will_save_change_to_starts_at? && starts_at.present? }
  before_destroy :raise_error, unless: -> { unscheduled? }
  after_save :calculate_total_score, unless: ->{ is_auto }
  after_save :check_labs_capacity, if: -> { saved_change_to_starts_at? && starts_at.present? && !_force }
  after_save :check_student_conflicts, if: -> { saved_change_to_starts_at? && starts_at.present? && !_force }
  after_update_commit :fire_jobs, if: -> { saved_change_to_starts_at? && starts_at.present? }
  after_update_commit :end_exam, if: -> { saved_change_to_duration? && starts_at.present? }
  after_update_commit :create_student_exams, if: -> { saved_change_to_status?(to: SCHEDULED) }

  # Non DB attributes
  attr_accessor :_force

  # Methods
  def valid_status_transition?(old_status, new_status)
    NEXT_VALID_TRANSITIONS[old_status.to_sym]&.include?(new_status.to_sym)
  end

  def generate_questions(question_type_topics = [])
    check_if_can_create

    questions_by_topic = nil
    question_type_topics.each do |object|
      selected_questions = Question.where(question_type_id: object[:question_type_id], topic_id: object[:topic_ids])

      questions_by_topic ||= selected_questions
      questions_by_topic = questions_by_topic.or(selected_questions)
    end

    template = ExamTemplate.find_by(course_id: course_id)
    question_types = course.question_types.where(id: question_type_topics.map { |object| object[:question_type_id] })
    questions = nil

    DIFFICULTIES.each do |difficulty|
      mins = duration * template.send(difficulty) / 100
      question_types.each do |type|
        if type.ratio.positive? 
          selected_questions = questions_by_topic.joins(:question_type)
                                               .where(question_type: type, difficulty: difficulty)
                                               .limit((mins * type.ratio / 100) / type.send("#{difficulty}_weight"))
                                               .select("questions.id, question_types.#{difficulty}_weight as score")
          questions ||= selected_questions
          questions = questions.union(selected_questions)
        end
      end
    end

    questions.map { |question| exam_questions.new(question_id: question.id, score: question.score) }

    self.total_score = exam_questions.sum(&:score)
  end

  def _force
    @_force || false
  end

  def number_of_students
    students.size
  end

  private

  def nullify_scheduling_attributes!
    self.starts_at = nil
    self.schedule_id = nil
    self.ends_at = nil
    busy_labs.destroy_all
    student_exams.destroy_all
  end

  def add_ends_at!
    self.ends_at = starts_at + duration.minutes
    busy_labs.map { |lab| lab.save! }
  end

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

  def check_starts_at_validty
    return unless starts_at < Time.now + 5.hours

    errors.add(:starts_at, :old_starts_at, strict: true)
  end

  def update_exam_status_scheduled
    self.status = :scheduled
  end

  def fire_jobs
    start_exam
    end_exam
    create_student_answers
  end

  def check_labs_capacity
    num_of_students = students.size
    labs_capacity = labs.sum(:capacity)
    return unless labs_capacity < num_of_students

    errors.add(:base, :capacity_not_enough, difference: num_of_students - labs_capacity, strict: true)
  end

  def check_student_conflicts
    overlapped_studens = Student.joins(:exams)
                                .where(faculty: course.faculty)
                                .where.not('exams.id = :id', id: id)
                                .where(exams: { status: %i[scheduled ongoing] })
                                .where(':start <= exams.ends_at and :end >= exams.starts_at',
                                       start: starts_at, end: ends_at)

    return unless overlapped_studens.present?

    errors.add(:base, :student_conflict, num_of_students: overlapped_studens.size, strict: true)
  end

  def start_exam
    UpdateExamStatusJob.set(wait_until: starts_at).perform_later({ exam_id: id,
                                                                   starts_at: starts_at,
                                                                   operation: 'start_exam' })
  end

  def end_exam
    UpdateExamStatusJob.set(wait_until: ends_at).perform_later({ exam_id: id,
                                                                 ends_at: ends_at,
                                                                 operation: 'end_exam' })
  end

  def create_student_answers
    tte = starts_at - 2.hours
    CreateStudentAnswerJob.set(wait_until: tte).perform_later({ exam_id: id,
                                                                starts_at: starts_at})
  end

  def create_student_exams
    student_exams_to_create = students.map do |student|
      { student_id: student.id }
    end
    student_exams.create!(student_exams_to_create)
  end
end

# == Schema Information
#
# Table name: exams
#
#  id                      :bigint           not null, primary key
#  duration                :integer
#  ends_at                 :datetime
#  has_models              :boolean          default(FALSE)
#  is_auto                 :boolean          default(FALSE)
#  pending_labs_assignment :boolean          default(TRUE)
#  starts_at               :datetime
#  status                  :integer
#  title                   :string
#  total_score             :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  course_id               :bigint           not null
#  schedule_id             :bigint
#  staff_id                :bigint           not null
#
# Indexes
#
#  index_exams_on_course_id    (course_id)
#  index_exams_on_schedule_id  (schedule_id)
#  index_exams_on_staff_id     (staff_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (schedule_id => schedules.id)
#  fk_rails_...  (staff_id => staffs.id)
#
