class AuthenticateUser

  def initialize(**args)
    @username = args[:username]
    @password = args[:password]
    @namespace = args[:namespace]
    @type = args[:type]
  end

  def call
    user = find_user

    raise_invalid_credentails unless user && user&.authenticate(password)

    [user, get_access_token(user)]
  end

  private
  
  attr_reader :username, :password, :namespace, :type

  def find_user
    type&.classify&.constantize&.find_by(username: username)
  end

  def get_access_token(user)
    JsonWebToken.encode(user_id: user.id, type: type, namespace: namespace)
  end

  def raise_invalid_credentails
    raise(ErrorHandler::AuthenticationError, I18n.t("authentication.invalid_credentials")) 
  end
end