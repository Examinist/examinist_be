class StaffPortal::QuestionTypesController < ApplicationController
  before_action :check_authorization_policy
  before_action :find_course, only: %i[index create update destroy]
  before_action :find_question_type, only: %i[update destroy]

  #######
  # List Question types for a specific course
  # GET: /staff_portal/courses/:course_id/question_types
  # Auth: Admin and Instructor assigned to this course
  #######
  def index
    render_response({ question_types: StaffPortal::QuestionTypeSerializer.new(@course.question_types,
                                                                              params: { show_details: true }).to_j }, :ok)
  end

  #######
  # Create Question type for a specific course
  # POST: /staff_portal/courses/:course_id/question_types
  # Auth: Admin and Instructor assigned to this course
  #######
  def create
    question_type = @course.question_types.create!(create_question_type_params)
    render_response({ question_type: StaffPortal::QuestionTypeSerializer.new(question_type,
                                                                             params: { show_details: true }).to_j }, :created)
  end

  #######
  # Update Question type for a specific course
  # PATCH: /staff_portal/courses/:course_id/question_types/:id
  # Auth: Admin and Instructor assigned to this course
  #######
  def update
    @question_type.update!(update_question_type_params)
    render_response({ question_type: StaffPortal::QuestionTypeSerializer.new(@question_type, 
                                                                             params: { show_details: true }).to_j }, :ok)
  end

  #######
  # Delete Question type for a specific course
  # DELETE: /staff_portal/courses/:course_id/question_types/:id
  # Auth: Admin and Instructor assigned to this course
  #######
  def destroy
    @question_type.destroy!
    render_response({ question_type: StaffPortal::QuestionTypeSerializer.new(@question_type, 
                                                                             params: { show_details: true }).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:staff_portal, QuestionType])
  end

  def create_question_type_params
    params.permit(:name, :easy_weight, :medium_weight, :hard_weight)
  end

  def update_question_type_params
    params.permit(:name, :easy_weight, :medium_weight, :hard_weight)
  end

  def find_course
    records = @current_user.assigned_courses
    @course = records.find(params[:course_id])
  end

  def find_question_type
    records = policy_scope([:staff_portal, QuestionType])
    @question_type = records.where(course: @course).find(params[:id])
  end
end