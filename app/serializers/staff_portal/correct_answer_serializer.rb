class StaffPortal::CorrectAnswerSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :answer
end