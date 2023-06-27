class StaffPortal::StudentExamsController < ApplicationController
  before_action :check_authorization_policy
  before_action :find_student_exam, only: %i[update show]

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
    render_response({ student_exams: StaffPortal::StudentExamSerializer.new(records.includes(:student)).to_j }, :ok, pagination: number_of_pages)
  end

  #######
  # Show Student Exam
  # GET: /staff_portal/exams/:exam_id/student_exams/:id
  # Auth: Admin and Instructor
  #######
  def show
    render_response({ student_exam: StaffPortal::StudentExamSerializer.new(@student_exam, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # Update Score of Student Exam
  # PATCH: /staff_portal/exams/:exam_id/student_exams/:id
  # Auth: Admin and Instructor
  #######
  def update
    @student_exam.update!(update_student_exam_params)
    render_response({ student_exam: StaffPortal::StudentExamSerializer.new(@student_exam, params: { show_details: true }).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:staff_portal, StudentExam])
  end

  def filtering_params
    params.permit(:filter_by_status)
  end

  def find_student_exam
    records = policy_scope_class.resolve
    # TODO: to be discussed
    # records = records.pending_grading if action_name == 'update'
    @student_exam = records.find(params[:id])
  end

  def update_student_exam_params
    params.permit(student_answers_attributes: %i[id score])
  end

  def policy_scope_class
    StaffPortal::StudentExamPolicy::Scope.new(@current_user, StudentExam, { exam_id: params[:exam_id] })
  end
end
