class CoordinatorPortal::StaffSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :first_name, :last_name, :username
end
