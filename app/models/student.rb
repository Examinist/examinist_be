class Student < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # Validations
  has_secure_password validations: false

  validates_presence_of :first_name, :last_name, :username
  validates_uniqueness_of :username
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password , length: { minimum: 6 }
  validates :academic_id, presence: true, uniqueness: { scope: :faculty }
  validates_presence_of :faculty


  # Associations
  belongs_to :faculty
  has_many :course_group_students
  has_many :course_groups, through: :course_group_students
  has_many :enrolled_courses, -> { distinct }, through: :course_groups, source: :course
  has_many :exams, through: :enrolled_courses
  has_many :student_exams, dependent: :nullify
end

# == Schema Information
#
# Table name: students
#
#  id                   :bigint           not null, primary key
#  email                :string
#  first_name           :string
#  last_name            :string
#  must_change_password :boolean          default(TRUE)
#  password_digest      :string
#  token_version        :bigint           default(0)
#  username             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  academic_id          :string
#  faculty_id           :bigint           not null
#
# Indexes
#
#  index_students_on_email       (email) UNIQUE
#  index_students_on_faculty_id  (faculty_id)
#
# Foreign Keys
#
#  fk_rails_...  (faculty_id => faculties.id)
#
