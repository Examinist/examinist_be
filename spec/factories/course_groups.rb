FactoryBot.define do
  factory :course_group do
    name { Faker::Alphanumeric.alpha(number: 5) }
    course
    end_date { '2023-03-13 20:10:11' }
  end
end

# == Schema Information
#
# Table name: course_groups
#
#  id         :bigint           not null, primary key
#  end_date   :datetime
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint           not null
#
# Indexes
#
#  index_course_groups_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
