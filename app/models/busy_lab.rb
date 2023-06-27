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
  before_update :can_assign_proctor?, if: -> { will_save_change_to_staff_id? }
  before_update :check_staff_is_proctor, if: -> { will_save_change_to_staff_id? }
  before_update :check_proctor_belongs_to_faculty, if: -> { will_save_change_to_staff_id? }

  private

  # Methods
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
