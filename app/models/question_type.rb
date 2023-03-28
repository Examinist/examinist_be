# frozen_string_literal: true

class QuestionType < ApplicationRecord

  # constants
  DEFAULT_TYPES = %w[Essay MCQ Short_Answer T/F].freeze

  # validations
  validates_presence_of :name
  validates_presence_of :easy_weight
  validates_presence_of :medium_weight
  validates_presence_of :hard_weight
  validates_presence_of :ratio
  validates :name, uniqueness: { scope: :course }
  validates_numericality_of :ratio, greater_than_or_equal_to: 0, less_than_or_equal_to: 100

  with_options on: :update do
    validate :validate_can_change_name, if: :name_changed?
  end

  # Associations
  belongs_to :course

  # Hooks
  before_destroy :check_if_can_be_deleted

  def is_deletable
    !DEFAULT_TYPES.include?(self.name)
  end

  # Methods
  private

  def validate_can_change_name
    errors.add(:name, :cant_be_changed, strict: true) if DEFAULT_TYPES.include?(name_was)
  end

  def check_if_can_be_deleted
    errors.add(:base, :cant_be_deleted, strict: true) if DEFAULT_TYPES.include?(self.name)
  end
end

# == Schema Information
#
# Table name: question_types
#
#  id            :bigint           not null, primary key
#  easy_weight   :integer          default(0)
#  hard_weight   :integer          default(0)
#  medium_weight :integer          default(0)
#  name          :string
#  ratio         :float            default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  course_id     :bigint           not null
#
# Indexes
#
#  index_question_types_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#
