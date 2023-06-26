class CoordinatorPortal::StaffsController < ApplicationController
  before_action :check_authorization_policy
  before_action :find_faculty, only: %i[index update]
  before_action :find_staff, only: %i[update]

  #######
  # List Staffs
  # GET: /coordinator_portal/faculties/:faculty_id/staffs
  # Auth: Coordinator
  #######
  def index
    render_response({ staffs: CoordinatorPortal::StaffSerializer.new(@faculty.staffs.instructor).to_j }, :ok)
  end

  #######
  # Update Staff
  # PATCH: /coordinator_portal/faculties/:faculty_id/staffs/:id
  # Auth: Coordinator
  #######
  def update
    @staff.update!(update_staff_params)
    render_response({ staff: CoordinatorPortal::StaffSerializer.new(@staff).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:coordinator_portal, Staff])
  end

  def find_faculty
    records = policy_scope([:coordinator_portal, Faculty])
    @faculty = records.find(params[:faculty_id])
  end

  def find_staff
    records = policy_scope([:coordinator_portal, Staff])
    @staff = records.where(faculty: @faculty).find(params[:id])
  end

  def update_staff_params
    params.permit(:role)
  end
end