# frozen_string_literal: true

FactoryBot.define do
  factory :correct_answer do
    question
    answer { Faker::Lorem.sentence }
  end
end

# == Schema Information
#
# Table name: correct_answers
#
#  id          :bigint           not null, primary key
#  answer      :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  choice_id   :bigint
#  question_id :bigint           not null
#
# Indexes
#
#  index_correct_answers_on_choice_id    (choice_id)
#  index_correct_answers_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (choice_id => choices.id)
#  fk_rails_...  (question_id => questions.id)
#
