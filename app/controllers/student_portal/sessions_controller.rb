class StudentPortal::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: %i[create]

  def create
    student, auth_token = authenticate_user('student')
    render_response({ student: StudentSerializer.new(student, params: { auth_token: auth_token }).to_j }, :ok)
  end

  def destroy
  end
end