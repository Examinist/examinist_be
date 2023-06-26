class CoordinatorPortal::FacultiesController < ApplicationController
  before_action :check_authorization_policy

  #######
  # List Faculties
  # GET: /coordinator_portal/faculties
  # Auth: Coordinator
  #######
  def index
    records = policy_scope([:coordinator_portal, Faculty])
    render_response({ faculties: CoordinatorPortal::FacultySerializer.new(records).to_j }, :ok)
  end

  private

  def check_authorization_policy
    authorize([:coordinator_portal, Faculty])
  end
end