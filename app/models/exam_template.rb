class ExamTemplate < ApplicationRecord
  
  # validations
  validates_presence_of :easy
  validates_presence_of :medium
  validates_presence_of :hard
  validates_presence_of :course_id
  with_options on: :update do
    validate :validate_sum_of_ratios
  end

  # Associations
  belongs_to :course
  has_many :question_types, through: :course

  # Nested Attributes
  accepts_nested_attributes_for :question_types

  # Methods
  private

  def validate_sum_of_ratios
    sum = easy + medium + hard
    errors.add(:base, :invalid_ratios) if sum != 100.0
  end
end

# == Schema Information
#
# Table name: exam_templates
#
#  id         :bigint           not null, primary key
#  easy       :float            default(60.0)
#  hard       :float            default(10.0)
#  medium     :float            default(30.0)
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint           not null
#
# Indexes
#
#  index_exam_templates_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
