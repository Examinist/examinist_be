class CourseGroupStaff < ApplicationRecord
  # Validations
  validates_presence_of :course_group_id
  validates_presence_of :staff_id
  validates :staff_id, uniqueness: { scope: :course_group }
  validate :validate_staff_in_faculty
  validate :validate_staff_ability_to_be_assigned

  #Associations
  belongs_to :course_group
  belongs_to :staff

  #Methods
  private

  def validate_staff_in_faculty  
    errors.add(:staff_id, :staff_not_in_faculty) unless staff&.faculty_id == course_group&.course_faculty_id
  end

  def validate_staff_ability_to_be_assigned
    errors.add(:staff_id, :staff_can_not_be_assigned) unless staff&.instructor? || staff&.admin?
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
