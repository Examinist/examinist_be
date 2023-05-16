class Lab < ApplicationRecord
  # Validations
  validates_presence_of :name, :capcity, :university_id
  validates :name,  uniqueness: { scope: :university }
  
  # Associations
  belongs_to :university
  has_many :busy_labs, dependent: :destroy
end

# == Schema Information
#
# Table name: labs
#
#  id            :bigint           not null, primary key
#  capcity       :integer
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :bigint           not null
#
# Indexes
#
#  index_labs_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
