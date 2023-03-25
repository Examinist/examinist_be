class StudentPortal::CoursesController < ApplicationController
  before_action :find_course, only: %i[show]
  #######
  # List Courses
  # GET: /student_portal/courses
  #######
  def index
    records = policy_scope([:student_portal, Course])
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    render_response({ courses: StudentPortal::CourseSerializer.new(records).to_j }, :ok)
  end

  #######
  # Show Course Info
  # GET: /student_portal/courses/:id
  #######
  def show
    render_response({ course_info: StudentPortal::CourseSerializer.new(@course, params: { show_details: true }).to_j }, :ok)
  end

  private

  def find_course
    records = policy_scope([:student_portal, Course])
    @course = records.find(params[:id])
  end
end
