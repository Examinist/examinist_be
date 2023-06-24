require 'net/http'

class StudentPortal::StudentExamsController < ApplicationController
  include Pundit
  before_action :check_authorization_policy
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
    render_response({ student_exams: StudentPortal::StudentExamSerializer.new(records, params: { list_exams: true }).to_j },
                      :ok, pagination: number_of_pages)
  end

  #######
  # List Student Exams (upcoming within 60 minutes & ongoing)
  # GET: /student_portal/student_exams/sixty_minutes_exams
  #######
  def sixty_minutes_exams
    records = policy_scope([:student_portal, StudentExam]).sixty_minutes
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    number_of_pages = @pagy.present? ? @pagy.pages : 1
    render_response({ student_exams: StudentPortal::StudentExamSerializer.new(records, params: { list_exams: true }).to_j },
                      :ok, pagination: number_of_pages)
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
end
