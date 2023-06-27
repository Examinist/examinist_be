# frozen_string_literal: true

class StudentAnswer < ApplicationRecord
  # validations
  validates_presence_of :student_exam, :exam_question
  validates :student_exam, uniqueness: { scope: :exam_question, message: I18n.t('activerecord.errors.duplicated',
                                                                                model_name: 'Student Answer') }
  validates :score, numericality: { greater_than_or_equal_to: 0.0 }, if: -> { score.present? }

  # Hooks
  before_update :check_score_validaty, if: -> { will_save_change_to_score? }
  before_update :check_question_type_grading_validaty, if: -> { will_save_change_to_score? && @auto_grading.nil? }

  # Associations
  belongs_to :student_exam
  belongs_to :exam_question

  # Non DB Attribute
  attr_accessor :auto_grading

  # Methods
  private

  def check_score_validaty
    errors.add(:score, :invalid_score, strict: true) if score > exam_question.score
  end

  def check_question_type_grading_validaty
    eq = exam_question.question
    errors.add(:base, :invalid_question_type, strict: true) if eq.mcq? || eq.true_or_false?
  end
end

# == Schema Information
#
# Table name: student_answers
#
#  id               :bigint           not null, primary key
#  answer           :string           default([]), is an Array
#  marked           :boolean          default(FALSE)
#  score            :float
#  solved           :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  exam_question_id :bigint           not null
#  student_exam_id  :bigint           not null
#
# Indexes
#
#  index_student_answers_on_exam_question_id  (exam_question_id)
#  index_student_answers_on_student_exam_id   (student_exam_id)
#
# Foreign Keys
#
#  fk_rails_...  (exam_question_id => exam_questions.id)
#  fk_rails_...  (student_exam_id => student_exams.id)
#
