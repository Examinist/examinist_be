class StaffPortal::QuestionTypeSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :easy_weight, :medium_weight, :hard_weight, :is_deletable, :ratio
end
