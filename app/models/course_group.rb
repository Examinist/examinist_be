class CourseGroup < ApplicationRecord
  # Validations
  validates_presence_of :name
  validates_presence_of :course_id
  validates_presence_of :end_date
  validates :name, uniqueness: { scope: :course }

  #Associations
  belongs_to :course
  has_and_belongs_to_many :students, join_table: "course_group_students"
  has_and_belongs_to_many :staffs, join_table: "course_group_staffs"

  #Methods

  #for add 1 or more students
  def add_students(students_list)
    students << students_list
  end

  def add_staffs(staffs_list)
    staffs << staffs_list
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
