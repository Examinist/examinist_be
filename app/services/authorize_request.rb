class AuthorizeRequest

  def initialize(**args)
    @headers = args[:headers]
    @namespace = args[:namespace]
  end

  def call
    decoded_jwt_token = decode_jwt_token
    raise_invalid_token unless decoded_jwt_token

    current_user = find_user(decoded_jwt_token)
    raise_invalid_token if current_user.nil?
    current_user
  rescue ActiveRecord::RecordNotFound
    raise_invalid_token
  end

  private

  attr_reader :headers, :namespace

  def find_user(decoded_jwt_token)
    return unless decoded_jwt_token[:namespace] == namespace

    decoded_jwt_token[:type]&.classify&.constantize&.find(decoded_jwt_token[:user_id])
  end

  def decode_jwt_token
    # rescue from error
    header = @headers['Authorization']
    header = header.split(' ').last if header
    JsonWebToken.decode(header)
  end

  def raise_invalid_token
    raise(ErrorHandler::AuthenticationError, I18n.t('authorization.invalid_credentials'))
  end
end