class CoordinatorPortal::FacultySerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :faculty_name
  
  attribute :admins do |object|
    CoordinatorPortal::StaffSerializer.new(object.staffs.admin).to_j
  end
end
