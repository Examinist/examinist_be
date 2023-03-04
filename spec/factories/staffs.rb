# frozen_string_literal: true

FactoryBot.define do
  factory :staff do
    email { Faker::Internet.email }
    name { Faker::Name.name   }
    password { "password" }
    role { %i[admin instuctor proctor].sample }
    faculty
  end
end

# == Schema Information
#
# Table name: staffs
#
#  id                   :bigint           not null, primary key
#  email                :string
#  must_change_password :boolean          default(TRUE)
#  name                 :string
#  password_digest      :string
#  role                 :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  faculty_id           :bigint           not null
#
# Indexes
#
#  index_staffs_on_email       (email) UNIQUE
#  index_staffs_on_faculty_id  (faculty_id)
#
# Foreign Keys
#
#  fk_rails_...  (faculty_id => faculties.id)
#
