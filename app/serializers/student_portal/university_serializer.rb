class StudentPortal::UniversitySerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
end
