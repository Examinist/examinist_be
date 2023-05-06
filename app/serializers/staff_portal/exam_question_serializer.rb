class StaffPortal::ExamQuestionSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :score

  attribute :question do |object|
    StaffPortal::QuestionSerializer.new(object.question).to_j
  end
end
