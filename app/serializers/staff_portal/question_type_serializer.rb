class StaffPortal::QuestionTypeSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attribute :id, :name, :easy_weight, :medium_weight, :hard_weight, :is_deletable
end
