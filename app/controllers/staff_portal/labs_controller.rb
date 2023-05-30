class StaffPortal::LabsController < ApplicationController
  before_action :check_authorization_policy

  #######
  # List Labs
  # GET: /staff_portal/labs
  # Auth: Admin only
  #######
  def index
    records = policy_scope([:staff_portal, Lab])
    render_response({ labs: StaffPortal::LabSerializer.new(records).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:staff_portal, Lab])
  end
end
