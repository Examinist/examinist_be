class StaffPortal::ChoiceSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :choice, :is_answer
end