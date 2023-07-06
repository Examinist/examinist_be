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

  def self.generate_schedule(params)
    schedule = Schedule.new
    schedule.title = params[:title]
    schedule.faculty_id = params[:faculty_id]
    labs = Lab.where(id: params[:lab_ids])
    exams = Exam.where(id: params[:exam_ids])
    schedule.check_can_create_schedule(exams)
    exam_days = schedule.get_exam_days(params[:schedule_from], params[:schedule_to], params[:holiday_dates],
                              params[:exam_week_days], params[:exam_starting_time])
    
    scheduled_exams = schedule.create_schedule(exam_days, exams.to_a, labs, [])
    raise(ErrorHandler::GeneralRequestError, I18n.t("schedule.cant_generate_schedule")) if scheduled_exams.size != exams.size

    schedule.exams = scheduled_exams
    schedule
  end

  def get_exam_days(schedule_from, schedule_to, holiday_dates, exam_week_days, time)
    exam_days = []
    schedule_from = schedule_from.split('-')
    schedule_to = schedule_to.split('-')
    time = time.split(':')
    current_date = DateTime.new(schedule_from.third.to_i, schedule_from.second.to_i, schedule_from.first.to_i, time.first.to_i, time.second.to_i, 0, "+3")
    end_date = DateTime.new(schedule_to.third.to_i, schedule_to.second.to_i, schedule_to.first.to_i, time.first.to_i, time.second.to_i, 0, "+3")
    holiday_dates = holiday_dates.map do |date|
      date = date.split('-')
      DateTime.new(date.third.to_i, date.second.to_i, date.first.to_i, time.first.to_i, time.second.to_i, 0, "+3")
    end

    while current_date <= end_date
      unless holiday_dates.include?(current_date) || !exam_week_days.include?(current_date.strftime('%A').downcase)
        exam_days << current_date
      end
      current_date += 1
    end

    exam_days
  end

  def create_schedule(exam_days, exams, labs, scheduled_exams)
    return scheduled_exams if exams.empty?

    current_exam = exams.shift
    exam_days.each do |day|
      available_labs = get_available_labs(current_exam.duration, day, labs) 
      next unless current_exam.can_schedule?(day, available_labs)

      scheduled_exams << current_exam
      new_exam_days = get_new_exam_days(exam_days, day, current_exam.duration)
      returned_scheduled_exams = create_schedule(new_exam_days, exams, labs, scheduled_exams.dup)

      # if could schedule all remaining exams
      if returned_scheduled_exams.size == scheduled_exams.size + exams.size
        current_exam.starts_at = day
        current_exam.assigned_labs = get_busy_labs(current_exam, available_labs)
        exams.unshift(current_exam)
        return returned_scheduled_exams
      else
        scheduled_exams.delete(current_exam)
      end
    end
    # couldn't find a day for this exam to schedule the rest
    exams.unshift(current_exam)
    return scheduled_exams
  end

  def  check_can_create_schedule(exams)
    scheduled_exams = exams.where.not(starts_at: nil)
    raise(ErrorHandler::GeneralRequestError, I18n.t("schedule.exams_scheduled_already")) if scheduled_exams.present?

    non_faculty_exams = exams.joins(:course).where.not('courses.faculty_id = ?', faculty_id)
    raise(ErrorHandler::GeneralRequestError, I18n.t("schedule.exams_not_same_faculty")) if non_faculty_exams.present?
  end

  # Methods
  private

  def get_available_labs(exam_duration, day, labs)
    busy_labs = BusyLab.where(lab_id: labs.pluck(:id))
                       .where(":start <= busy_labs.end_date and :end >= busy_labs.start_date",
                              start: day, end: day + exam_duration.minutes)

    labs.where.not(id: busy_labs.pluck(:lab_id))
  end

  def get_new_exam_days(exam_days, day, duration)
    new_exam_days = exam_days.dup
    new_exam_days.delete(day)

    new_date = day + duration.minutes + 1.hour
    limit_time = day.change(hour: 19, minute: 0, second: 0)
    new_exam_days << new_date if new_date < limit_time
    new_exam_days
  end

  def get_busy_labs(exam, labs)
    number_of_students = exam.students.size
    selected_labs = []
    labs.order(capacity: :desc)
    count = 0
    while(number_of_students > 0)
      lab = labs.where('capacity >= ?', number_of_students)
                .where.not(id: selected_labs.pluck(:id))
                .order(capacity: :asc).first
      
      unless lab.present?
        lab = labs[count]
        count += 1
      end
      number_of_students -= lab.capacity
      selected_labs << lab
    end
    selected_labs
  end

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
