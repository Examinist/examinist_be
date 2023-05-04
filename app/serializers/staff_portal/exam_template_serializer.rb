class StaffPortal::ExamTemplateSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :easy, :medium, :hard

  attribute :must_update_template do |object|
    object.easy.nil? && object.medium.nil? && object.hard.nil?
  end

  attribute :question_types do |object|
    StaffPortal::QuestionTypeSerializer.new(object.question_types).to_j
  end

  attribute :course do |object|
    StaffPortal::CourseSerializer.new(object.course).to_j
  end
end
