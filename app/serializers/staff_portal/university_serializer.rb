class StaffPortal::UniversitySerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
end
