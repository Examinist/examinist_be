class Staff < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # Enum
  enum role: { admin: 0, instructor: 1, proctor: 2 }

  # Validations
  has_secure_password validations: false

  validates_presence_of :first_name, :last_name, :username
  validates_uniqueness_of :username
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password , length: { minimum: 6 }, if: :will_save_change_to_password_digest?
  validates_presence_of :role
  validates_presence_of :faculty

  # Associations
  belongs_to :faculty
  has_many :course_group_staffs
  has_many :course_groups, through: :course_group_staffs
  has_many :assigned_courses, -> { distinct }, through: :course_groups, source: :course
  has_many :course_topics, through: :assigned_courses, source: :topics
  has_many :course_question_types, through: :assigned_courses, source: :question_types
  has_many :course_questions, through: :assigned_courses, source: :questions
  has_many :exams, dependent: :destroy
  has_many :courses_exams, through: :assigned_courses, source: :exams
  has_many :labs, through: :faculty
  has_many :schedules, through: :faculty
  has_many :student_exams, through: :courses_exams

  # Scopes
  scope :filter_by_role, ->(role) { where(role: role) }
  scope :filter_by_faculty_id, ->(faculty_id) { where(faculty_id: faculty_id) }
end

# == Schema Information
#
# Table name: staffs
#
#  id                   :bigint           not null, primary key
#  email                :string
#  first_name           :string
#  last_name            :string
#  must_change_password :boolean          default(TRUE)
#  password_digest      :string
#  role                 :integer
#  username             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  faculty_id           :bigint           not null
#
# Indexes
#
#  index_staffs_on_email       (email) UNIQUE
#  index_staffs_on_faculty_id  (faculty_id)
#
# Foreign Keys
#
#  fk_rails_...  (faculty_id => faculties.id)
#
