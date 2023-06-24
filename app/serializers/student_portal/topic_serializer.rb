class StudentPortal::TopicSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
end