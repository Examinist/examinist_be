# frozen_string_literal: true

FactoryBot.define do
  factory :student do
    email { Faker::Internet.email }
    first_name { Faker::Name.name   }
    last_name { Faker::Name.name   }
    username { Faker::Code.sin }
    password { "password" }
    academic_id { Faker::Code.sin }
    faculty
  end
end

# == Schema Information
#
# Table name: students
#
#  id                   :bigint           not null, primary key
#  email                :string
#  first_name           :string
#  last_name            :string
#  must_change_password :boolean          default(TRUE)
#  password_digest      :string
#  username             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  academic_id          :string
#  faculty_id           :bigint           not null
#
# Indexes
#
#  index_students_on_email       (email) UNIQUE
#  index_students_on_faculty_id  (faculty_id)
#
# Foreign Keys
#
#  fk_rails_...  (faculty_id => faculties.id)
#
