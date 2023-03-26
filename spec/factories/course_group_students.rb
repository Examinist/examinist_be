FactoryBot.define do
  factory :course_group_student do
    course_group
    student
  end
end

# == Schema Information
#
# Table name: course_group_students
#
#  course_group_id :bigint
#  student_id      :bigint
#
# Indexes
#
#  index_course_group_students_on_course_group_id  (course_group_id)
#  index_course_group_students_on_student_id       (student_id)
#
