class StaffPortal::CorrectAnswerSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :answer, :choice_id
end