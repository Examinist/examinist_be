# frozen_string_literal: true

class Question < ApplicationRecord
  # Enum
  enum difficulty: { easy: 0, medium: 1, hard: 2 }
  enum answer_type: { single_answer: 0, multiple_answers: 1, text_answer: 2, pdf_answer: 3 }

  # validations
  validates_presence_of :question_type_id, :course_id, :topic_id, :header, :difficulty, :answer_type, :correct_answers
  validates_presence_of :number_of_choices, if: -> { true_or_false? && mcq? }
  validates_presence_of :choices, if: :mcq?
  validate :validate_size_of_choices, if: -> { number_of_choices.present? && mcq? }
  validate :validate_all_ids_in_same_course
  validate :validate_answer_type_with_question_type
  validate :validate_correct_answer_with_question_type

  # Associations
  belongs_to :topic
  belongs_to :question_type
  belongs_to :course
  has_many :correct_answers, dependent: :destroy, inverse_of: :question
  has_many :choices, dependent: :destroy, inverse_of: :question

  # Nested Attributes
  accepts_nested_attributes_for :choices, allow_destroy: true
  accepts_nested_attributes_for :correct_answers, allow_destroy: true

  # Hooks
  before_validation :set_number_of_choices, if: :true_or_false?
  after_create :set_choices, if: :true_or_false?

  # Scopes
  scope :filter_by_header, ->(header) { where('header ILIKE :header', header: "%#{header}%") }
  scope :filter_by_topic_id, ->(topic_id) { where(topic_id: topic_id) }
  scope :filter_by_question_type_id, ->(question_type_id) { where(question_type_id: question_type_id) }
  scope :filter_by_difficulty, ->(difficulty) { where(difficulty: difficulty.to_sym) }

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

  def validate_size_of_choices
    return if choices.size == number_of_choices

    errors.add(:base, :choices_size)
  end

  def validate_all_ids_in_same_course
    errors.add(:base, :invalid_topic) unless Topic.find(topic_id).course_id == course_id
    errors.add(:base, :invalid_question_type) unless QuestionType.find(question_type_id).course_id == course_id
  end

  def validate_answer_type_with_question_type
    case answer_type.to_sym
    when :single_answer
      errors.add(:base, :invalid_answer_type) unless mcq? || true_or_false?
    when :multiple_answers
      errors.add(:base, :invalid_answer_type) unless mcq?
    when :text_answer
      errors.add(:base, :invalid_answer_type) unless short_answer? || essay? || other_question_types?
    when :pdf_answer
      errors.add(:base, :invalid_answer_type) unless essay? || other_question_types?
    end
  end

  def validate_correct_answer_with_question_type
    case answer_type.to_sym
    when :multiple_answers
      errors.add(:base, :invalid_correct_answer) unless correct_answers.size > 1
    else
      errors.add(:base, :invalid_correct_answer) unless correct_answers.size == 1
    end
  end

  def set_number_of_choices
    self.number_of_choices = QuestionType::DEFAULT_T_F_CHOICES.size
  end

  def set_choices
    QuestionType::DEFAULT_T_F_CHOICES.each do |choice|
      choices.create(choice: choice)
    end
  end
end

# == Schema Information
#
# Table name: questions
#
#  id                :bigint           not null, primary key
#  answer_type       :integer
#  difficulty        :integer
#  header            :text
#  number_of_choices :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  course_id         :bigint           not null
#  question_type_id  :bigint
#  topic_id          :bigint
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
