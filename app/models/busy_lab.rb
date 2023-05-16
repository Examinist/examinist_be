class BusyLab < ApplicationRecord
  # Validations
  validates_presence_of :start_date, :end_date, :lab_id, :exam_id
  validates_datetime :end_date, after: :start_date 
  validate :lab_is_busy?
  # Associations
  belongs_to :lab
  belongs_to :exam

  private

  # Methods
  def lab_is_busy?
    overlapped_busy_labs = BusyLab.where(lab_id: lab_id)
                                  .where(':start <= busy_labs.end_date and :end >= busy_labs.start_date',
                                         start: start_date, end: end_date)
    return unless overlapped_busy_labs.present?

    errors.add(:lab_id, :is_busy)
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
#
# Indexes
#
#  index_busy_labs_on_exam_id  (exam_id)
#  index_busy_labs_on_lab_id   (lab_id)
#
# Foreign Keys
#
#  fk_rails_...  (exam_id => exams.id)
#  fk_rails_...  (lab_id => labs.id)
#
