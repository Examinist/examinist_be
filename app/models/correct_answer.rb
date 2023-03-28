# frozen_string_literal: true

class CorrectAnswer < ApplicationRecord
  # Validations
  validates_presence_of :answer

  # Associations
  belongs_to :question, inverse_of: :correct_answers
end

# == Schema Information
#
# Table name: correct_answers
#
#  id          :bigint           not null, primary key
#  answer      :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint           not null
#
# Indexes
#
#  index_correct_answers_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (question_id => questions.id)
#
