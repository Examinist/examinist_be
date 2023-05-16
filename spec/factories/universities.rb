FactoryBot.define do
  factory :university do
    name { Faker::Educator.university }
  end
end

# == Schema Information
#
# Table name: universities
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
