class StaffPortal::StudentAnswerSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :answer, :score

  attribute :exam_question do |object|
    StaffPortal::ExamQuestionSerializer.new(object.exam_question).to_j
  end
end
