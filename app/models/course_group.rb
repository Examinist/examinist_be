class CourseGroup < ApplicationRecord
  # Validations
  validates_presence_of :name
  validates_presence_of :course_id
  validates_presence_of :end_date
  validates :name, uniqueness: { scope: :course }

  # Associations
  belongs_to :course
  has_many :course_group_students
  has_many :students, through: :course_group_students
  has_many :course_group_staffs
  has_many :staffs, through: :course_group_staffs

  # Delegations
  delegate :faculty_id, to: :course, prefix: true
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
