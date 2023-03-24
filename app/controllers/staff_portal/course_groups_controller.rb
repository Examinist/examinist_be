class StaffPortal::CourseGroupsController < ApplicationController
  before_action :chech_authorization_policy
  before_action :find_course, only: %i[index]
  #######
  # List Course Groups for a specific course
  # GET: /staff_portal/courses/:course_id/course_groups
  # Auth: Admin and Instructor
  #######
  def index
    render_response({ course_groups: StaffPortal::CourseGroupSerializer.new(@course.course_groups).to_j }, :ok)
  end

  private

  def chech_authorization_policy
    authorize([:staff_portal, CourseGroup])
  end

  def find_course
    records = policy_scope([:staff_portal, Course])
    @course = records.find(params[:course_id])
  end
end
