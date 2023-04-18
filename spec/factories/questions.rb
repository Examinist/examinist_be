# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    course
    topic { |evaluator| Topic.where(course: evaluator.course).sample }
    trait :with_mcq do
      question_type_id { |evaluator| QuestionType.where(course: evaluator.course).find_by_name('MCQ').id }
      answer_type { 'multiple_answers' }
    end

    trait :with_t_f do
      question_type_id { |evaluator| QuestionType.where(course: evaluator.course).find_by_name('T/F').id }
      answer_type { 'single_answer' }
    end

    trait :with_essay do
      question_type_id { |evaluator| QuestionType.where(course: evaluator.course).find_by_name('Essay').id }
      answer_type { 'pdf_answer' }
    end

    trait :with_short_answer do
      question_type_id { |evaluator| QuestionType.where(course: evaluator.course).find_by_name('Short_Answer').id }
      answer_type { 'text_answer' }
    end
    difficulty { %i[easy medium hard].sample }
    header { Faker::Lorem.sentence }

    after(:build) do |question|
      if question.mcq?
        5.times.each do
          question.correct_answers << FactoryBot.build(:correct_answer, question: question)
        end

        3.times.each do
          question.choices << FactoryBot.build(:choice, question: question)
        end
      else
        question.correct_answers << FactoryBot.build(:correct_answer, question: question)
      end
    end
  end
end

# == Schema Information
#
# Table name: questions
#
#  id               :bigint           not null, primary key
#  answer_type      :integer
#  difficulty       :integer
#  header           :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  course_id        :bigint           not null
#  question_type_id :bigint
#  topic_id         :bigint
#
# Indexes
#
#  index_questions_on_course_id         (course_id)
#  index_questions_on_question_type_id  (question_type_id)
#  index_questions_on_topic_id          (topic_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (question_type_id => question_types.id)
#  fk_rails_...  (topic_id => topics.id)
#
