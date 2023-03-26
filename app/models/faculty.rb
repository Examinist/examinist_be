# frozen_string_literal: true

class Faculty < ApplicationRecord
  # Validations
  validates :faculty_name,  uniqueness: { scope: :university_name }
  validates_presence_of :faculty_name
  validates_presence_of :university_name
end

# == Schema Information
#
# Table name: faculties
#
#  id              :bigint           not null, primary key
#  faculty_name    :string
#  university_name :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
