class StaffPortal::StudentExamSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :status

  attribute :student_status do |object|
    # TODO: get this attribute from the control module
    object&.student_status
  end

  attribute :student do |object|
    StaffPortal::StudentSerializer.new(object.student).to_j
  end

  attribute :partial_graded_questions do |object|
    object&.partial_graded_questions
  end

  attribute :total_graded_questions do |object|
    object&.student_answers&.size
  end

  attribute :partial_score do |object|
    object&.partial_score
  end

  attribute :total_score do |object|
    object&.total_score
  end
end
