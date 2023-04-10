# frozen_string_literal: true

class Choice < ApplicationRecord
  # Validations
  validates_presence_of :choice

  # Associations
  belongs_to :question, inverse_of: :choices
end

# == Schema Information
#
# Table name: choices
#
#  id          :bigint           not null, primary key
#  choice      :text
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
