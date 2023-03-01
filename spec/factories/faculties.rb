# frozen_string_literal: true

FactoryBot.define do
  factory :faculty do
    faculty_name { Faker::Educator.campus }
    university_name { Faker::Educator.university }
  end
end

# == Schema Information
#
# Table name: faculties
#
#  id              :bigint           not null, primary key
#  faculty_name    :string
#  university_name :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
