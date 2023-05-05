module ErrorHandler
  extend ActiveSupport::Concern

  ################### Custom Error Subclasses ####################
  class AuthenticationError < StandardError; end

  class AuthorizationError < StandardError; end

  class GeneralRequestError < StandardError; end

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

    rescue_from ActiveRecord::RecordInvalid do |err|
      raise_error(:unprocessable_entity, err.message.gsub("Validation failed: ", ""))
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

    rescue_from ActiveModel::StrictValidationFailed do |err|
      raise_error(:bad_request, err.message)
    end

    rescue_from JWT::DecodeError do |err|
      raise_error(:unauthorized, I18n.t('authorization.decode_error'))
    end

    rescue_from ErrorHandler::GeneralRequestError do |err|
      raise_error(:bad_request, err.message)
    end

    rescue_from ActiveRecord::RecordNotUnique do |err|
      model_name = err.message.match(/"index_([a-z_]+)_on_/)[1]
      raise_error(:bad_request, I18n.t('activerecord.errors.duplicated', model_name: model_name))
    end
  end
end
