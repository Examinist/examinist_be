# frozen_string_literal: true

class Faculty < ApplicationRecord
  # Validations
  validates :faculty_name,  uniqueness: { scope: :university }
  validates_presence_of :faculty_name, :university_id

  # Associations
  belongs_to :university
  has_many :courses, dependent: :destroy
  has_many :exams, through: :courses
  has_many :schedules, dependent: :destroy
end

# == Schema Information
#
# Table name: faculties
#
#  id            :bigint           not null, primary key
#  faculty_name  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :bigint           not null
#
# Indexes
#
#  index_faculties_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
