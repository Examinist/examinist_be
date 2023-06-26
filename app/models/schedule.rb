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

  def self.schedule_bulk_exams(params)
    schedule = Schedule.new
    schedule.handle_bulk_exams(params)
  end

  def handle_bulk_exams(params)
    updated_exams = []
    ActiveRecord::Base.transaction do
      self.title = params[:title]
      self.faculty_id = params[:faculty_id]
      exams_with_course = Exam.joins(:course).where('courses.faculty_id = ?', params[:faculty_id])
      exams = params[:exams]
      exams.each do |exam_obj|
        exam = exams_with_course.find(exam_obj[:id])
        errors.add(:base, :exam_already_scheduled, strict: true) if exam.scheduled?

        exam.update!(_force: exam_obj[:_force], starts_at: exam_obj[:starts_at], busy_labs_attributes: exam_obj[:busy_labs_attributes])
        updated_exams << exam
      end
    end
    self.exams << updated_exams
    save!
    self
  end

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
