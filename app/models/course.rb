class Course < ApplicationRecord
  # Validations
  validates_presence_of :title
  validates_presence_of :code
  validates_presence_of :faculty_id
  validates :code, uniqueness: { scope: :faculty }

  #Associations
  belongs_to :faculty
  has_many :course_groups, dependent: :destroy
  has_many :students, -> { distinct }, through: :course_groups
  has_many :staffs, -> { distinct }, through: :course_groups
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
