class StaffPortal::StaffSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :first_name, :last_name, :username, :role
  attribute :auth_token, if: proc { |_record, params| params && params[:auth_token] } do |_object, params|
    params[:auth_token]
  end

  ####################### Show Details ############################
  attributes :email, if: proc { |_record, params| params && params[:show_details] }
  attribute :faculty, if: proc { |_record, params| params && params[:show_details] } do |object|
    StaffPortal::FacultySerializer.new(object.faculty).to_j
  end
end

# == Schema Information
#
# Table name: staffs
#
#  id                   :bigint           not null, primary key
#  email                :string
#  first_name           :string
#  last_name            :string
#  must_change_password :boolean          default(TRUE)
#  password_digest      :string
#  role                 :integer
#  username             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  faculty_id           :bigint           not null
#
# Indexes
#
#  index_staffs_on_email       (email) UNIQUE
#  index_staffs_on_faculty_id  (faculty_id)
#
# Foreign Keys
#
#  fk_rails_...  (faculty_id => faculties.id)
#
