class StaffPortal::TopicSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name

  ####################### Show Details ############################
  attribute :course, if: proc { |_record, params| params && params[:show_details] } do |object|
    StaffPortal::CourseSerializer.new(object.course).to_j
  end
end