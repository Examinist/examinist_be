FactoryBot.define do
  factory :coordinator do
    username { Faker::Internet.username }
    university
    email { Faker::Internet.email }
    password { 'password' }
  end
end

# == Schema Information
#
# Table name: coordinators
#
#  id              :bigint           not null, primary key
#  email           :string
#  password_digest :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  university_id   :bigint           not null
#
# Indexes
#
#  index_coordinators_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
