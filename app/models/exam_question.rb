class ExamQuestion < ApplicationRecord
  
  # Validations
  validates_presence_of :score, :exam, :question
  validates :question_id, uniqueness: { scope: :exam, message: I18n.t('activerecord.errors.duplicated',
                                                               model_name: 'exam_questions') }

  # Associations
  belongs_to :exam, touch: true
  belongs_to :question
  has_one :question_type, through: :question
  has_many :student_answers, dependent: :destroy

  # Hooks
  before_save :check_questions_belong_to_course

  private

  # Methods
  def check_questions_belong_to_course
    return if exam.course_id == question.course_id

    errors.add(:question_id, :question_doesnot_belong_to_course, question_id: question_id, strict: true)
  end

end

# == Schema Information
#
# Table name: exam_questions
#
#  id          :bigint           not null, primary key
#  score       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  exam_id     :bigint           not null
#  question_id :bigint           not null
#
# Indexes
#
#  index_exam_questions_on_exam_id                  (exam_id)
#  index_exam_questions_on_exam_id_and_question_id  (exam_id,question_id) UNIQUE
#  index_exam_questions_on_question_id              (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (exam_id => exams.id)
#  fk_rails_...  (question_id => questions.id)
#
