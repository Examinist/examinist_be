FactoryBot.define do
  factory :busy_lab do
    lab
    start_date { (Time.current + 1.day).to_s  }
    end_date { (Time.current + 1.day + 2.hour).to_s  }
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
