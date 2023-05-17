class CoordinatorPortal::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: %i[create]

  #######
  # Log in
  # POST: /coordinator_portal/sessions
  # Auth: any coordinator
  #######
  def create
    coordinator, auth_token = authenticate_user('coordinator')
    render_response({ coordinator: CoordinatorPortal::CoordinatorSerializer.new(coordinator,
                                                                          params: { auth_token: auth_token }).to_j }, :ok)
  end
end
