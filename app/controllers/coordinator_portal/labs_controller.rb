class CoordinatorPortal::LabsController < ApplicationController
  before_action :check_authorization_policy
  before_action :find_lab, only: %i[update destroy]
  before_action :find_university, only: %i[create]

  #######
  # List Labs
  # GET: /coordinator_portal/labs
  # Auth: Coordinator
  #######
  def index
    records = policy_scope([:coordinator_portal, Lab])
    render_response({ labs: CoordinatorPortal::LabSerializer.new(records).to_j }, :ok)
  end

  #######
  # Create Lab
  # POST: /coordinator_portal/labs
  # Auth: Coordinator
  #######
  def create
    lab = @university.labs.create!(create_lab_params)
    render_response({ lab: CoordinatorPortal::LabSerializer.new(lab, params: { show_details: true }).to_j }, :created)
  end

  #######
  # Update Lab
  # PATCH: /coordinator_portal/labs/:id
  # Auth: Coordinator
  #######
  def update
    @lab.update!(update_lab_params)
    render_response({ lab: CoordinatorPortal::LabSerializer.new(@lab, params: { show_details: true }).to_j }, :ok)
  end

  #######
  # Delete Lab
  # DELETE: /coordinator_portal/labs/:id
  # Auth: Coordinator
  #######
  def destroy
    @lab.destroy!
    render_response({ lab: CoordinatorPortal::LabSerializer.new(@lab, params: { show_details: true }).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:coordinator_portal, Lab])
  end

  def find_university
    @university = @current_user.university
  end

  def find_lab
    records = policy_scope([:coordinator_portal, Lab])
    @lab = records.find(params[:id])
  end

  def create_lab_params
    params.permit(:name, :capacity)
  end

  def update_lab_params
    params.permit(:name, :capacity)
  end
end
