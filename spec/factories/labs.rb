FactoryBot.define do
  factory :lab do
    name { "Lab #{Random.rand(1...1000)}" }
    capacity { Random.rand(1...200) }
    university
  end
end

# == Schema Information
#
# Table name: labs
#
#  id            :bigint           not null, primary key
#  capacity      :integer
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :bigint           not null
#
# Indexes
#
#  index_labs_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
