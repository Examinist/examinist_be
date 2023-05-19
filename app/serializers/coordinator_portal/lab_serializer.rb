class CoordinatorPortal::LabSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :capacity

  ####################### Show Details ############################
  attribute :university, if: proc { |_record, params| params && params[:show_details] } do |object|
    CoordinatorPortal::UniversitySerializer.new(object.university).to_j
  end
end
