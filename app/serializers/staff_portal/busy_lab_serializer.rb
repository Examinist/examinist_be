class StaffPortal::BusyLabSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name

  attribute :proctor, if: proc { |_record, params| params && params[:show_details] } do |object|
    StaffPortal::StaffSerializer.new(object.staff).to_j
  end
end
