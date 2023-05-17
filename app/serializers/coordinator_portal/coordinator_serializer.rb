class CoordinatorPortal::CoordinatorSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :username, :email

  attribute :university do |object|
    CoordinatorPortal::UniversitySerializer.new(object.university).to_j
  end

  attribute :auth_token, if: proc { |_record, params| params && params[:auth_token] } do |_object, params|
    params[:auth_token]
  end
end
