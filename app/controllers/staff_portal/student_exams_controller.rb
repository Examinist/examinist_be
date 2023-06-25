class StaffPortal::StudentExamsController < ApplicationController
  before_action :check_authorization_policy

  #######
  # List Student Exams for a specific exam
  # GET: /staff_portal/exams/:exam_id/student_exams
  # Auth: Admin and Instructor
  #######
  def index
    records = policy_scope_class.resolve
    filtering_params.each do |key, value|
      records = records.send(key, value) if value.present?
    end
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    number_of_pages = @pagy.present? ? @pagy.pages : 1
    render_response({ student_exams: StaffPortal::StudentExamSerializer.new(records).to_j }, :ok, pagination: number_of_pages)
  end

  private

  def check_authorization_policy
    authorize([:staff_portal, StudentExam])
  end

  def filtering_params
    params.permit(:filter_by_status)
  end

  def policy_scope_class
    'StaffPortal::StudentExamPolicy::Scope'.constantize
                                           .new(@current_user, StudentExam, { exam_id: params[:exam_id] })
  end
end
