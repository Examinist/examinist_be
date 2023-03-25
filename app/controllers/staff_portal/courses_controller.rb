class StaffPortal::CoursesController < ApplicationController
  before_action :chech_authorization_policy
  before_action :find_course, only: %i[show]
  #######
  # List Courses
  # GET: /staff_portal/courses
  # Auth: Admin and Instructor
  #######
  def index
    records = policy_scope([:staff_portal, Course])
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    render_response({ courses: StaffPortal::CourseSerializer.new(records).to_j }, :ok)
  end

  #######
  # Show Course Info
  # GET: /staff_portal/courses/:id
  # Auth: Admin and Instructor
  #######
  def show
    render_response({ course_info: StaffPortal::CourseSerializer.new(@course, params: { show_details: true }).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:staff_portal, Course])
  end

  def find_course
    records = policy_scope([:staff_portal, Course])
    @course = records.find(params[:id])
  end
end
