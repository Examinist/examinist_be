class StaffPortal::QuestionsController < ApplicationController
  before_action :check_authorization_policy
  before_action :find_course, only: %i[index create update destroy]
  before_action :find_question, only: %i[update destroy]

  #######
  # List Questions for a specific course
  # GET: /staff_portal/courses/:course_id/questions
  # Auth: Admin and Instructor
  #######
  def index
    records = policy_scope([:staff_portal, Question]).where(course: @course)
    filtering_params.each do |key, value|
      records = records.send(key, value) if value.present?
    end
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    render_response({ questions: StaffPortal::QuestionSerializer.new(records).to_j }, :ok)
  end

  #######
  # Create Question for a specific course
  # POST: /staff_portal/courses/:course_id/questions
  # Auth: Admin and Instructor
  #######
  def create
    question = @course.questions.create!(create_question_params)
    render_response({ question: StaffPortal::QuestionSerializer.new(question, show_details: true).to_j }, :created)
  end

  #######
  # Update Question for a specific course
  # PATCH: /staff_portal/courses/:course_id/questions/:id
  # Auth: Admin and Instructor
  #######
  def update
    @question.update!(update_question_params)
    render_response({ question: StaffPortal::QuestionSerializer.new(@question, show_details: true).to_j }, :ok)
  end

  #######
  # Delete Question for a specific course
  # DELETE: /staff_portal/courses/:course_id/questions/:id
  # Auth: Admin and Instructor
  #######
  def destroy
    @question.destroy!
    render_response({ question: StaffPortal::QuestionSerializer.new(@question, show_details: true).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:staff_portal, Question])
  end

  def find_course
    records = @current_user.assigned_courses
    @course = records.find(params[:course_id])
  end

  def find_question
    records = policy_scope([:staff_portal, Question])
    @question = records.where(course: @course).find(params[:id])
  end

  def filtering_params
    params.permit(:filter_by_header, :filter_by_topic_id, :filter_by_question_type_id, :filter_by_difficulty)
  end

  def create_question_params
    params.permit(:header, :difficulty, :answer_type, :question_type_id, :topic_id, choices_attributes: [:choice],
                  correct_answers_attributes: [:answer])
  end

  def update_question_params
    params.permit(:header, :difficulty, :answer_type, :topic_id, choices_attributes: %i[id _destroy choice],
                  correct_answers_attributes: %i[id _destroy answer])
  end
end