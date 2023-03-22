module ResponseHandler
  extend ActiveSupport::Concern

  def render_response(data, status_code, error_msg = nil)
    render(
      json: { status: error_msg.nil? ? "success" : "failure" }.merge(data, message: error_msg),
      status: status_code
    )
  end
end