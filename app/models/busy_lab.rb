class BusyLab < ApplicationRecord
  # Associations
  belongs_to :lab
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
#  lab_id     :bigint           not null
#
# Indexes
#
#  index_busy_labs_on_lab_id  (lab_id)
#
# Foreign Keys
#
#  fk_rails_...  (lab_id => labs.id)
#
