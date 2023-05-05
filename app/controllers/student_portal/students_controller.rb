class StudentPortal::StudentsController < ApplicationController
  def user_info
    render_response({ user_info: StudentPortal::StudentSerializer.new(@current_user).to_j }, :ok)
  end
end