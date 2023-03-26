FactoryBot.define do
  factory :course_group_staff do
    course_group
    staff
  end
end

# == Schema Information
#
# Table name: course_group_staffs
#
#  id              :bigint           not null, primary key
#  course_group_id :bigint
#  staff_id        :bigint
#
# Indexes
#
#  index_course_group_staffs_on_course_group_id  (course_group_id)
#  index_course_group_staffs_on_staff_id         (staff_id)
#
