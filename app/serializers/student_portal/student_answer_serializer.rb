class StudentPortal::StudentAnswerSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :answer

  attribute :question do |object|
    StudentPortal::QuestionSerializer.new(object.exam_question.question).to_j
  end
end