class StudentPortal::SessionsController < ApplicationController
  skip_before_action :authorize_request, only: %i[create]

  def create
    student, auth_token = authenticate_user('student')
    render_response({ student: StudentPortal::StudentSerializer.new(student, params: { auth_token: auth_token }).to_j }, :ok)
  end

  def destroy
    @current_user.increment!(:token_version)
    render_response({}, :ok)
  end
end