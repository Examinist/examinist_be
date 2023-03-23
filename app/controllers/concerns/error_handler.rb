module ErrorHandler
  extend ActiveSupport::Concern

  ################### Custom Error Subclasses ####################
  class AuthenticationError < StandardError; end

  class AuthorizationError < StandardError; end

  def raise_error(status_code, error_msg)
    render(
      json: { status: "error" }.merge(message: error_msg),
      status: status_code
    )
  end

  included do
    # Catch record not found exception
    rescue_from ActiveRecord::RecordNotFound do |err|
      raise_error(:not_found, 
                  I18n.t("activerecord.errors.not_found", model: I18n.t("activerecord.models.#{err.model.downcase}"),
                                                          id: err.id))
    end

    # JSON response with message; Status code 401 - Unauthorized
    rescue_from ErrorHandler::AuthorizationError do |err|
      raise_error(:unauthorized, err.message)
    end

    # JSON response with message; Status code 401 - Unauthorized
    rescue_from ErrorHandler::AuthenticationError do |err|
      raise_error(:unauthorized, err.message)
    end

    # JSON response with message; Status code 401 - Unauthorized
    rescue_from Pundit::NotAuthorizedError do |err|
      raise_error(:unauthorized, I18n.t('authorization.unauthorized_action'))
    end
  end
end
