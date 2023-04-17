class StaffPortal::ExamTemplateSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :easy, :medium, :hard, :course_id

  attribute :question_types do |object|
    StaffPortal::QuestionTypeSerializer.new(object.question_types, params: { template_details: true }).to_j
  end
end
