class StaffPortal::CourseSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :code
end
