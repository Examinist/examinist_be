class StaffPortal::StaffsController < ApplicationController
  def user_info
    render_response({ user_info: StaffPortal::StaffSerializer.new(@current_user).to_j }, :ok)
  end
end