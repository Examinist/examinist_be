class Staff < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  #Enum
  enum role: { admin: 0, instuctor: 1, proctor: 2 }

  #Validations
  validates_presence_of :name
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password , length: { minimum: 6 }
  validates_presence_of :role
  validates_presence_of :faculty
  has_secure_password

  #Associations
  belongs_to :faculty
  has_and_belongs_to_many :course_groups, join_table: "course_group_staffs"
end

# == Schema Information
#
# Table name: staffs
#
#  id                   :bigint           not null, primary key
#  email                :string
#  must_change_password :boolean          default(TRUE)
#  name                 :string
#  password_digest      :string
#  role                 :integer
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
