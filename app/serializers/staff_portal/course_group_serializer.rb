class StaffPortal::CourseGroupSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :end_date

  attribute :instructors do |object|
    StaffPortal::StaffSerializer.new(object.staffs).to_j
  end

  attribute :students do |object|
    StudentPortal::StudentSerializer.new(object.students).to_j
  end
end
