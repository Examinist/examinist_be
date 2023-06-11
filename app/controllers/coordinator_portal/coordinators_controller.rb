class CoordinatorPortal::CoordinatorsController < ApplicationController
  #######
  # get the current user's information
  # GET: /coordinator_portal/coordinators/user_info
  # Auth: any coordinator
  #######
  def user_info
    render_response({ user_info: CoordinatorPortal::CoordinatorSerializer.new(@current_user).to_j }, :ok)
  end
end
