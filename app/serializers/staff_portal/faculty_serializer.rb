class StaffPortal::FacultySerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :faculty_name, :university_name
end

# == Schema Information
#
# Table name: faculties
#
#  id              :bigint           not null, primary key
#  faculty_name    :string
#  university_name :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
