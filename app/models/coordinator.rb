class Coordinator < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # Validations
  has_secure_password validations: false

  validates_presence_of :username, :university_id
  validates_uniqueness_of :username
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password , length: { minimum: 6 }, if: :will_save_change_to_password_digest?

  # Associations
  belongs_to :university
  has_many :labs, through: :university
  has_many :faculties, through: :university
  has_many :staffs, through: :faculties
end

# == Schema Information
#
# Table name: coordinators
#
#  id              :bigint           not null, primary key
#  email           :string
#  password_digest :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  university_id   :bigint           not null
#
# Indexes
#
#  index_coordinators_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
