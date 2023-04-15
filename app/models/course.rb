class Course < ApplicationRecord

  # validations
  validates_presence_of :title
  validates_presence_of :code
  validates_presence_of :faculty_id
  validates_presence_of :credit_hours
  validates :code, uniqueness: { scope: :faculty }

  # Associations
  belongs_to :faculty
  has_many :course_groups, dependent: :destroy
  has_many :students, -> { distinct }, through: :course_groups
  has_many :staffs, -> { distinct }, through: :course_groups
  has_many :topics, dependent: :delete_all
  has_many :question_types, dependent: :delete_all

  # Hooks
  after_create_commit :create_default_question_types

  # Methods
  private

  def create_default_question_types
    QuestionType::DEFAULT_TYPES.each do |type|
      question_types.create(name: type, ratio: 25.0)
    end
  end
end

# == Schema Information
#
# Table name: courses
#
#  id           :bigint           not null, primary key
#  code         :string
#  credit_hours :integer
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  faculty_id   :bigint           not null
#
# Indexes
#
#  index_courses_on_faculty_id  (faculty_id)
#
# Foreign Keys
#
#  fk_rails_...  (faculty_id => faculties.id)
#
