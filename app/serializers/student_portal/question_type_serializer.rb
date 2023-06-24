class StudentPortal::QuestionTypeSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
end
