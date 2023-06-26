class StudentPortal::BusyLabSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
end