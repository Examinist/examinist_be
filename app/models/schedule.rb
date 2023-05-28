# frozen_string_literal: true

class Schedule < ApplicationRecord
  # Associations
  belongs_to :faculty
  has_many :exams
  has_many :busy_labs, through: :exams

  # Nested Attributes
  accepts_nested_attributes_for :exams

  # Hooks
  before_destroy :check_exams_status
  before_destroy :change_exams_status!

  # Methods
  private

  def check_exams_status
    return if exams.all? { |exam| exam.scheduled? }

    errors.add(:base, :cant_be_deleted, strict: true)
  end

  def change_exams_status!
    Exam.transaction do
      exams.each do |exam|
        exam.unscheduled!
      end
    end
  end
end

# == Schema Information
#
# Table name: schedules
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  faculty_id :bigint           not null
#
# Indexes
#
#  index_schedules_on_faculty_id  (faculty_id)
#
# Foreign Keys
#
#  fk_rails_...  (faculty_id => faculties.id)
#
