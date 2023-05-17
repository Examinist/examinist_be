class CoordinatorPortal::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: %i[create]

  def create
    coordinator, auth_token = authenticate_user('coordinator')
    render_response({ staff: CoordinatorPortal::CoordinatorSerializer.new(coordinator,
                                                                          params: { auth_token: auth_token }).to_j }, :ok)
  end
end
