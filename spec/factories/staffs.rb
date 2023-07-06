# frozen_string_literal: true

FactoryBot.define do
  factory :staff do
    email { Faker::Internet.email }
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    username { Faker::Internet.username }
    password { 'password' }
    role { %i[admin instructor proctor].sample }
    faculty
  end
end

# == Schema Information
#
# Table name: staffs
#
#  id                   :bigint           not null, primary key
#  email                :string
#  first_name           :string
#  last_name            :string
#  must_change_password :boolean          default(TRUE)
#  password_digest      :string
#  role                 :integer
#  token_version        :bigint           default(0)
#  username             :string
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
