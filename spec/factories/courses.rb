FactoryBot.define do
  factory :course do
    title { Faker::Educator.course_name }
    code { Faker::Code.nric }
    faculty
  end
end

# == Schema Information
#
# Table name: courses
#
#  id         :bigint           not null, primary key
#  code       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  faculty_id :bigint           not null
#
# Indexes
#
#  index_courses_on_faculty_id  (faculty_id)
#
# Foreign Keys
#
#  fk_rails_...  (faculty_id => faculties.id)
#
