class StaffPortal::CoursesController < ApplicationController
  before_action :check_authorization_policy
  before_action :find_course, only: %i[show exam_template update_exam_template]
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

  #######
  # Show Course Exam Template
  # GET: /staff_portal/courses/:id/exam_template
  # Auth: Admin and Instructor
  #######
  def exam_template
    render_response({ exam_template: StaffPortal::ExamTemplateSerializer.new(@course.exam_template).to_j }, :ok)
  end

  #######
  # Update Course Exam Template
  # PATCH: /staff_portal/courses/:id/update_exam_template
  # Auth: Admin and Instructor
  #######
  def update_exam_template
    @course.exam_template.update!(update_exam_template_params)
    render_response({ exam_template: StaffPortal::ExamTemplateSerializer.new(@course.exam_template).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:staff_portal, Course])
  end

  def find_course
    records = policy_scope([:staff_portal, Course])
    @course = records.find(params[:id])
  end

  def update_exam_template_params
    params.permit(:easy, :medium, :hard, question_types_attributes: %i[id ratio])
  end
end
