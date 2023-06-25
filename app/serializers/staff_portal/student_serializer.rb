class StaffPortal::StudentSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :first_name, :last_name, :username, :email, :academic_id
  attribute :role do
    'student'
  end
end
