# frozen_string_literal: true

class Topic < ApplicationRecord
  # Validations
  validates_presence_of :name, :course_id
  validates :name,  uniqueness: { scope: :course }

  # Associations
  belongs_to :course
end

# == Schema Information
#
# Table name: topics
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint           not null
#
# Indexes
#
#  index_topics_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
