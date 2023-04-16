class StaffPortal::QuestionSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :header, :difficulty, :number_of_choices, :answer_type

  attribute :topic do |object|
    StaffPortal::TopicSerializer.new(object.topic).to_j
  end

  attribute :question_type do |object|
    StaffPortal::QuestionTypeSerializer.new(object.question_type).to_j
  end

  attribute :choices do |object|
    StaffPortal::ChoiceSerializer.new(object.choices).to_j
  end

  attribute :correct_answers do |object|
    StaffPortal::CorrectAnswerSerializer.new(object.correct_answers).to_j
  end

  ####################### Show Details ############################
  attribute :course, if: proc { |_record, params| params && params[:show_details] } do |object|
    StaffPortal::CourseSerializer.new(object.course).to_j
  end

end