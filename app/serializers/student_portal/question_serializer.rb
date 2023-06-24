class StudentPortal::QuestionSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :header, :difficulty, :answer_type

  attribute :topic do |object|
    StudentPortal::TopicSerializer.new(object.topic).to_j
  end

  attribute :question_type do |object|
    StudentPortal::QuestionTypeSerializer.new(object.question_type).to_j
  end

  attribute :choices do |object|
    StudentPortal::ChoiceSerializer.new(object.choices).to_j
  end

  ####################### Show Details ############################
  attribute :course, if: proc { |_record, params| params && params[:show_details] } do |object|
    StudentPortal::CourseSerializer.new(object.course).to_j
  end
end