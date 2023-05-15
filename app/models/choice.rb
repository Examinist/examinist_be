# frozen_string_literal: true

class Choice < ApplicationRecord
  # Validations
  validates_presence_of :choice

  # Associations
  belongs_to :question, inverse_of: :choices, touch: true
  has_one :correct_answer, dependent: :destroy

  # Hooks
  after_create :create_correct_answer, if: :is_answer
  after_update :update_correct_answer

  ########################### Methods ###########################
  private

  def create_correct_answer
    create_correct_answer!(answer: choice, question_id: question_id)
  end

  def update_correct_answer
    if is_answer && !correct_answer.present?
      create_correct_answer
    elsif !is_answer && correct_answer.present?
      correct_answer.destroy!
    elsif is_answer && correct_answer.present? && previous_changes[:choice]
      correct_answer.update!(answer: choice)
    end
  end
end

# == Schema Information
#
# Table name: choices
#
#  id          :bigint           not null, primary key
#  choice      :text
#  is_answer   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint           not null
#
# Indexes
#
#  index_choices_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
