class StaffPortal::TopicSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name

  attribute :course do |object|
    StaffPortal::CourseSerializer.new(object.course).to_j
  end
end