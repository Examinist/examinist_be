class StudentPortal::CoursesController < ApplicationController
  #######
  # List Courses
  # GET: /student_portal/courses
  #######
  def index
    records = policy_scope([:student_portal, Course])
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    render_response({ courses: StudentPortal::CourseSerializer.new(records).to_j }, :ok)
  end
end
