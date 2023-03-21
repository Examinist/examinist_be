class StaffPortal::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: %i[create]

  def create
    staff, auth_token = authenticate_user('staff')
    render_response({ staff: StaffSerializer.new(staff, params: { auth_token: auth_token }).to_j }, :ok)
  end

  def destroy
  end
end