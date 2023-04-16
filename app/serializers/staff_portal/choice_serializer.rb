class StaffPortal::ChoiceSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :choice
end