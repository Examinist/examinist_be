class CourseGroupStudent < ApplicationRecord
  # Validations
  validates_presence_of :course_group_id
  validates_presence_of :student_id
  validate :validate_student_in_faculty
  validate :validate_uniqueness_of_student_per_course

  # Associations
  belongs_to :course_group
  belongs_to :student

  # Methods
  private

  def validate_student_in_faculty  
    errors.add(:student_id, :student_not_in_faculty) unless student.faculty_id == course_group.course_faculty_id
  end

  def validate_uniqueness_of_student_per_course
    errors.add(:student_id, :student_already_enrolled_into_course) if student.enrolled_courses.include?(course_group.course)
  end
end

# == Schema Information
#
# Table name: course_group_students
#
#  id              :bigint           not null, primary key
#  course_group_id :bigint
#  student_id      :bigint
#
# Indexes
#
#  index_course_group_students_on_course_group_id  (course_group_id)
#  index_course_group_students_on_student_id       (student_id)
#
