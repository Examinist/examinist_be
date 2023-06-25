# frozen_string_literal: true

class StudentAnswer < ApplicationRecord
  # validations
  validates_presence_of :student_exam, :exam_question
  validates :student_exam, uniqueness: { scope: :exam_question, message: I18n.t('activerecord.errors.duplicated',
                                                                                model_name: 'Student Answer') }
  validates :score, numericality: { greater_than_or_equal_to: 0.0 }, if: -> { score.present? }

  # Associations
  belongs_to :student_exam
  belongs_to :exam_question
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
