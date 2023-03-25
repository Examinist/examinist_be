class StaffPortal::CoursesController < ApplicationController
  before_action :check_authorization_policy
  #######
  # List Courses
  # GET: /staff_portal/courses
  # Auth: Instructor
  #######
  def index
    records = policy_scope([:staff_portal, Course])
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    render_response({ courses: StaffPortal::CourseSerializer.new(records).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:staff_portal, Course])
  end
end
