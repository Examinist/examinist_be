# frozen_string_literal: true

FactoryBot.define do
  factory :choice do
    question
    choice { Faker::Lorem.sentence }

    trait :answer do
      is_answer { true }
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
