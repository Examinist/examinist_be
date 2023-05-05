class StudentPortal::StudentSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :first_name, :last_name, :username
  attribute :role do
    'student'
  end
  attribute :auth_token, if: proc { |_record, params| params && params[:auth_token] } do |_object, params|
    params[:auth_token]
  end

  ####################### Show Details ############################
  attributes :email, :academic_id, if: proc { |_record, params| params && params[:show_details] }
  attribute :faculty, if: proc { |_record, params| params && params[:show_details] } do |object|
    StudentPortal::FacultySerializer.new(object.faculty).to_j
  end
end

# == Schema Information
#
# Table name: students
#
#  id                   :bigint           not null, primary key
#  email                :string
#  first_name           :string
#  last_name            :string
#  must_change_password :boolean          default(TRUE)
#  password_digest      :string
#  username             :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  academic_id          :string
#  faculty_id           :bigint           not null
#
# Indexes
#
#  index_students_on_email       (email) UNIQUE
#  index_students_on_faculty_id  (faculty_id)
#
# Foreign Keys
#
#  fk_rails_...  (faculty_id => faculties.id)
#
