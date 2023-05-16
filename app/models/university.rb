class University < ApplicationRecord
  # validations
  validates_presence_of :name

  # Associations
  has_many :faculties, dependent: :destroy
  has_many :labs, dependent: :destroy
end

# == Schema Information
#
# Table name: universities
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
