# frozen_string_literal: true
# Question.create!(question_type_id:2, course_id:1, topic_id:1, header:"dummy", difficulty:0, answer_type:1, choices_attributes:[{choice:"x", is_answer: true},{choice:"y", is_answer: true}, {choice:"z"}])
# Question.first.update!(choices_attributes:[{id:2, is_answer:false},{id:3, is_answer:false}])
class Question < ApplicationRecord
  # Enum
  enum difficulty: { easy: 0, medium: 1, hard: 2 }
  enum answer_type: { single_answer: 0, multiple_answers: 1, text_answer: 2, pdf_answer: 3 }

  # validations
  validates_presence_of :question_type_id, :course_id, :topic_id, :header, :difficulty, :answer_type
  validates_presence_of :choices, if: -> { mcq? || true_or_false? }
  validate :validate_all_ids_in_same_course
  validate :validate_answer_type_with_question_type

  # Associations
  belongs_to :topic
  belongs_to :question_type
  belongs_to :course
  has_many :correct_answers, dependent: :destroy, inverse_of: :question
  has_many :choices, dependent: :destroy, inverse_of: :question

  # Nested Attributes
  accepts_nested_attributes_for :choices, allow_destroy: true
  accepts_nested_attributes_for :correct_answers, allow_destroy: true

  # Scopes
  scope :filter_by_header, ->(header) { where('header ILIKE :header', header: "%#{header}%") }
  scope :filter_by_topic_id, ->(topic_id) { where(topic_id: topic_id) }
  scope :filter_by_question_type_id, ->(question_type_id) { where(question_type_id: question_type_id) }
  scope :filter_by_difficulty, ->(difficulty) { where(difficulty: difficulty.to_sym) }

  # Hooks
  after_create :check_presence_of_correct_answer
  after_create :validate_correct_answer_with_answer_type
  before_update :can_update?
  before_update :check_question_type_change
  before_destroy :can_destroy?
  after_update :check_presence_of_correct_answer
  after_update :validate_correct_answer_with_answer_type

  # Methods
  def mcq?
    question_type_id == QuestionType.where(course_id: course_id).find_by_name('MCQ').id
  end

  def true_or_false?
    question_type_id == QuestionType.where(course_id: course_id).find_by_name('T/F').id
  end

  def essay?
    question_type_id == QuestionType.where(course_id: course_id).find_by_name('Essay').id
  end

  def short_answer?
    question_type_id == QuestionType.where(course_id: course_id).find_by_name('Short_Answer').id
  end

  def other_question_types?
    QuestionType.where(course_id: course_id).where.not(name: QuestionType::DEFAULT_TYPES).ids.include?(question_type_id)
  end

  private

  def check_question_type_change
    errors.add(:question_type_id, :invalid_update, strict: true) if question_type_id_changed?
  end

  def validate_all_ids_in_same_course
    errors.add(:topic_id, :invalid_topic) unless Topic.find(topic_id).course_id == course_id
    errors.add(:question_type_id, :invalid_question_type) unless QuestionType.find(question_type_id).course_id == course_id
  end

  def validate_answer_type_with_question_type
    case answer_type.to_sym
    when :single_answer
      errors.add(:answer_type, :invalid_answer_type) unless mcq? || true_or_false?
    when :multiple_answers
      errors.add(:answer_type, :invalid_answer_type) unless mcq?
    when :text_answer
      errors.add(:answer_type, :invalid_answer_type) unless short_answer? || essay? || other_question_types?
    when :pdf_answer
      errors.add(:answer_type, :invalid_answer_type) unless essay? || other_question_types?
    end
  end

  def validate_correct_answer_with_answer_type
    case answer_type.to_sym
    when :multiple_answers
      errors.add(:base, :invalid_correct_answer, strict: true) unless correct_answers.size >= 1
    else
      errors.add(:base, :invalid_correct_answer, strict: true) unless correct_answers.size == 1
    end
  end

  def check_presence_of_correct_answer
    errors.add(:base, :blank_correct_answer, strict: true) unless correct_answers.present?
  end

  def can_update?
    exam_questions = ExamQuestion.joins(:exam)
                                 .where(question_id: id)
                                 .where(exam: { status: %i[ongoing pending_grading] })
    
    return unless exam_questions.present?

    errors.add(:base, :cannot_update, strict: true)
  end

  def can_destroy?
    return unless ExamQuestion.where(question_id: id).present?

    errors.add(:base, :cannot_destroy, strict: true)
  end
end

# == Schema Information
#
# Table name: questions
#
#  id               :bigint           not null, primary key
#  answer_type      :integer
#  difficulty       :integer
#  header           :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  course_id        :bigint           not null
#  question_type_id :bigint
#  topic_id         :bigint
#
# Indexes
#
#  index_questions_on_course_id         (course_id)
#  index_questions_on_question_type_id  (question_type_id)
#  index_questions_on_topic_id          (topic_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (question_type_id => question_types.id)
#  fk_rails_...  (topic_id => topics.id)
#
