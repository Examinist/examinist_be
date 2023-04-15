class StaffPortal::QuestionSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :header, :difficulty, :number_of_choices, :answer_type,
             :question_type_id, :topic_id

  attribute :course do |object|
    StaffPortal::CourseSerializer.new(object.course).to_j
  end
end