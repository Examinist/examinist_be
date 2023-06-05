class StaffPortal::LabSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :capacity
end
