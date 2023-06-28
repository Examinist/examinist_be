class StaffPortal::BusyLabsController < ApplicationController
  before_action :check_authorization_policy
  before_action :find_busy_lab, only: %i[update students available_proctors]

  #######
  # Update Busy Lab
  # PATCH: /staff_portal/busy_labs
  # Auth: Admin
  #######
  def update
    @busy_lab.update!(update_busy_lab_params)
    render_response({ busy_lab: StaffPortal::BusyLabSerializer.new(@busy_lab, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # List Busy Lab Students
  # GET: /staff_portal/busy_labs/:id/students
  # Auth: Admin
  #######
  def students
    render_response({ students: StaffPortal::StudentSerializer.new(@busy_lab.students).to_j }, :ok)
  end

  #######
  # List Busy Lab available proctors
  # GET: /staff_portal/busy_labs/:id/available_proctors
  # Auth: Admin
  #######
  def available_proctors
    render_response({ proctors: StaffPortal::StaffSerializer.new(@busy_lab.available_proctors).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:staff_portal, BusyLab])
  end

  def update_busy_lab_params
    params.permit(:staff_id)
  end

  def policy_scope_class
    StaffPortal::BusyLabPolicy::Scope.new(@current_user, BusyLab, { exam_id: params[:exam_id] })
  end

  def find_busy_lab
    records = policy_scope_class.resolve
    @busy_lab = records.find(params[:id])
  end
end
