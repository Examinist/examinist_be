# frozen_string_literal: true

FactoryBot.define do
  factory :faculty do
    faculty_name { Faker::Educator.campus }
    university
  end
end

# == Schema Information
#
# Table name: faculties
#
#  id            :bigint           not null, primary key
#  faculty_name  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :bigint           not null
#
# Indexes
#
#  index_faculties_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
