class BusyLab < ApplicationRecord
  # Validations
  validates_presence_of :lab_id, :exam_id, :start_date, :end_date
  validates_presence_of :staff, if: :staff_id
  validates_datetime :end_date, after: :start_date
  validate :lab_is_busy?, if: -> { !exam._force && will_save_change_to_lab_id? }

  # Associations
  belongs_to :lab
  belongs_to :exam
  belongs_to :staff, optional: true
  delegate :name, to: :lab

  # Hooks
  before_validation :add_dates!
  before_update :can_assign_proctor?, if: -> { will_save_change_to_staff_id? && staff_id.present? }
  before_update :check_staff_is_proctor, if: -> { will_save_change_to_staff_id? && staff_id.present? }
  before_update :check_proctor_belongs_to_faculty, if: -> { will_save_change_to_staff_id? && staff_id.present? }
  before_update :check_proctor_not_busy, if: -> { will_save_change_to_staff_id? && staff_id.present? }
  after_update :check_pending_labs_assignment_status, if: -> { saved_change_to_staff_id? }

  # Methods  
  def students
    all_students = exam.students.order(academic_id: :asc)
    available_busy_labs = exam.busy_labs.order(id: :asc)
    sum = 0
    available_busy_labs.each do |bl|
      break if bl == self

      sum += bl.lab.capacity
    end
    position = available_busy_labs.ids.index(self.id)
    students = all_students.offset(sum)
    students = students.limit(self.lab.capacity) if position + 1 < available_busy_labs.size
    students
  end

  def available_proctors
    proctors = Staff.left_outer_joins(:proctored_busy_labs)
                    .where(role: :proctor, faculty_id: exam.course.faculty_id)
                    .where(':start > busy_labs.end_date or :end < busy_labs.start_date or busy_labs.id is NULL',
                           start: start_date, end: end_date)
                    .distinct         
  end

  private

  def lab_is_busy?
    overlapped_busy_labs = BusyLab.where(lab_id: lab_id)
                                  .where(':start <= busy_labs.end_date and :end >= busy_labs.start_date',
                                         start: start_date, end: end_date)
    return unless overlapped_busy_labs.present?

    errors.add(:lab_id, :is_busy, strict: true)
  end

  def add_dates!
    self.start_date = exam.starts_at
    self.end_date = exam.ends_at
  end

  def can_assign_proctor?
    return if exam.scheduled?

    errors.add(:staff_id, :cannot_assign_proctor, strict: true)
  end

  def check_staff_is_proctor
    return if staff.proctor?

    errors.add(:staff_id, :staff_not_proctor, strict: true)
  end

  def check_proctor_belongs_to_faculty
    return if staff.faculty_id == exam.course.faculty_id

    errors.add(:staff_id, :proctor_doesnot_belong_to_faculty, strict: true)    
  end

  def check_pending_labs_assignment_status
    if exam.busy_labs.all? { |busy_lab| busy_lab.staff_id.present? }
      exam.update_columns(pending_labs_assignment: false)
    else
      exam.update_columns(pending_labs_assignment: true)
    end
  end

  def check_proctor_not_busy
    return unless BusyLab.where.not(id: id)
                         .where(':start <= busy_labs.end_date and :end >= busy_labs.start_date',
                                start: start_date, end: end_date)
                         .where(staff_id: staff_id)
                         .present?
    
    errors.add(:staff_id, :proctor_is_busy, strict: true)
  end
end

# == Schema Information
#
# Table name: busy_labs
#
#  id         :bigint           not null, primary key
#  end_date   :datetime
#  start_date :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  exam_id    :bigint           not null
#  lab_id     :bigint           not null
#  staff_id   :bigint
#
# Indexes
#
#  index_busy_labs_on_exam_id   (exam_id)
#  index_busy_labs_on_lab_id    (lab_id)
#  index_busy_labs_on_staff_id  (staff_id)
#
# Foreign Keys
#
#  fk_rails_...  (exam_id => exams.id)
#  fk_rails_...  (lab_id => labs.id)
#  fk_rails_...  (staff_id => staffs.id)
#
