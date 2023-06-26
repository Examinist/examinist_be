require 'net/http'

class StudentPortal::StudentExamsController < ApplicationController
  include Pundit
  before_action :check_authorization_policy
  before_action :find_student_exam, only: %i[update show]

  #######
  # List Student Exams
  # GET: /student_portal/student_exams
  #######
  def index
    records = policy_scope([:student_portal, StudentExam])
    filtering_params.each do |key, value|
      records = records.send(key, value) if value.present?
    end
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    number_of_pages = @pagy.present? ? @pagy.pages : 1
    render_response({ student_exams: StudentPortal::StudentExamSerializer.new(records).to_j }, :ok, pagination: number_of_pages)
  end

  #######
  # Show Student Exam
  # GET: /student_portal/student_exams/:id
  # Auth: any student (inside university labs)
  #######
  def show
    render_response({ student_exam: StudentPortal::StudentExamSerializer.new(@student_exam, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # Update Student Exam
  # PATCH: /student_portal/student_exams/:id
  # Auth: any student (inside university labs)
  #######
  def update
    @student_exam.update!(update_student_exam_params)
    render_response({ student_exam: StudentPortal::StudentExamSerializer.new(@student_exam, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # List Student Exams (upcoming within 60 minutes & ongoing)
  # GET: /student_portal/student_exams/sixty_minutes_exams
  # Auth: any student (inside university labs)
  #######
  def sixty_minutes_exams
    records = policy_scope([:student_portal, StudentExam]).sixty_minutes
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    number_of_pages = @pagy.present? ? @pagy.pages : 1
    render_response({ student_exams: StudentPortal::StudentExamSerializer.new(records).to_j }, :ok, pagination: number_of_pages)
  end

  private

  def pundit_user
    client_ip = request.headers['X-Forwarded-For'] || request.remote_ip
    UserContext.new(@current_user, client_ip)
  end

  def check_authorization_policy
    authorize([:student_portal, StudentExam])
  end

  def filtering_params
    params.permit(:filter_by_status)
  end

  def find_student_exam
    records = policy_scope([:student_portal, StudentExam])
    @student_exam = records.ongoing.find(params[:id])
  end

  def update_student_exam_params
    params.permit(:is_submitting, student_answers_attributes: [:id, :marked, :solved, answer: []])
  end
end
