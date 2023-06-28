require 'net/http'

class StaffPortal::ExamsController < ApplicationController
  include Pundit
  before_action :check_authorization_policy
  before_action :find_exam, only: %i[update destroy show]

  #######
  # List Exams
  # GET: /staff_portal/exams
  # Auth: Admin and Instructor
  #######
  def index
    records = policy_scope_class.resolve
    filtering_params.each do |key, value|
      records = records.send(key, value) if value.present?
    end
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    number_of_pages = @pagy.present? ? @pagy.pages : 1
    proctoring_lab = @current_user.proctor? ? true : nil
    render_response({ exams: StaffPortal::ExamSerializer.new(records.order(updated_at: :desc),
                                                             params: { proctoring_lab: proctoring_lab, user: @current_user }).to_j },
                    :ok, pagination: number_of_pages)
  end

  #######
  # Show Exam
  # GET: /staff_portal/exams/:id
  # Auth: Admin and Instructor
  #######
  def show
    render_response({ exam: StaffPortal::ExamSerializer.new(@exam, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # Create Exam
  # POST: /staff_portal/exams
  # Auth: Admin and Instructor
  #######
  def create
    exam = Exam.create!(create_exam_params)
    render_response({ exam: StaffPortal::ExamSerializer.new(exam, params: { show_details: true }).to_j }, :created)
  end

  #######
  # Update Exam
  # PATCH: /staff_portal/exams/:id
  # Auth: Admin and Instructor
  #######
  def update
    @exam.update!(update_exam_params)
    render_response({ exam: StaffPortal::ExamSerializer.new(@exam, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # Delete Exam
  # DELETE: /staff_portal/exams/:id
  # Auth: Admin and Instructor
  #######
  def destroy
    @exam.destroy!
    render_response({ exam: StaffPortal::ExamSerializer.new(@exam, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # Generate Exam Automaticalliy
  # POST: /staff_portal/exams/auto_create
  # Auth: Admin and Instructor
  #######
  def auto_generate
    exam = Exam.new(auto_generate_exam_params)
    exam.generate_questions(generate_questions_params)
    render_response({ exam: StaffPortal::AutoExamSerializer.new(exam, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # List Exams (upcoming within 60 minutes & ongoing)
  # GET: /staff_portal/exams/sixty_minutes_exams
  # Auth: Proctor Only (inside university labs)
  #######
  def sixty_minutes_exams
    records = policy_scope_class.resolve.sixty_minutes
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    number_of_pages = @pagy.present? ? @pagy.pages : 1
    render_response({ exams: StaffPortal::ExamSerializer.new(records, params: { proctoring_lab: true, user: @current_user }).to_j },
                    :ok, pagination: number_of_pages)
  end

  private

  def pundit_user
    client_ip = request.headers['X-Forwarded-For'] || request.remote_ip
    UserContext.new(@current_user, client_ip)
  end

  def check_authorization_policy
    authorize([:staff_portal, Exam])
  end

  def find_exam
    records = policy_scope_class.resolve
    @exam = records.find(params[:id])
  end

  def filtering_params
    params.permit(:filter_by_status)
  end

  def create_exam_params
    params.permit(:title, :duration, :is_auto, :course_id, :has_models, exam_questions_attributes: %i[question_id score])
          .merge(staff_id: @current_user.id)
  end

  def update_exam_params
    params.permit(:title, :duration, :has_models, exam_questions_attributes: %i[id _destroy question_id score])
  end

  def auto_generate_exam_params
    params.permit(:course_id, :title, :duration, :has_models).merge(is_auto: true, staff_id: @current_user.id)
  end

  def generate_questions_params
    permitted_params = params.permit(question_type_topics: [:question_type_id, topic_ids: []])
    permitted_params[:question_type_topics]
  end

  def policy_scope_class
    'StaffPortal::ExamPolicy::Scope'.constantize
                                    .new(pundit_user, Exam, { action_name: action_name, course_id: params[:course_id] })
  end
end
