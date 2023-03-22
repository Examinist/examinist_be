class ApplicationController < ActionController::API
  include ErrorHandler
  include ResponseHandler

  before_action :authorize_request

  cattr_reader :current_user

  def authenticate_user(type)
    AuthenticateUser.new(
      username: params[:username],
      password: params[:password],
      namespace: self.class.name.split('::')[0],
      type: type
    ).call
  end

  def authorize_request
    @current_user = AuthorizeRequest.new(
      headers: request.headers,
      namespace: self.class.name.split('::')[0]
    ).call
  end
end