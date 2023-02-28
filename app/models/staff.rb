class Staff < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  enum role: { admin: 0, instuctor: 1, proctor: 2 }

  validates_presence_of :name
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password , length: { minimum: 6 }
  validates_presence_of :role
  has_secure_password

  belongs_to :faculty
end