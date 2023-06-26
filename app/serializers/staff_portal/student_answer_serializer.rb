class StaffPortal::StudentAnswerSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :answer, :score

  attribute :question do |object|
    StaffPortal::QuestionSerializer.new(object.exam_question.question).to_j
  end
end
