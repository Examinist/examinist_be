class StudentPortal::CourseSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :code

  ####################### Show Details ############################
  attributes :credit_hours, if: proc { |_record, params| params && params[:show_details] }

  attribute :instructors, if: proc { |_record, params| params && params[:show_details] } do |object|
    StaffPortal::StaffSerializer.new(object.staffs).to_j
  end

  attribute :students, if: proc { |_record, params| params && params[:show_details] } do |object|
    StudentPortal::StudentSerializer.new(object.students).to_j
  end
end
