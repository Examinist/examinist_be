module ResponseHandler
  extend ActiveSupport::Concern

  def render_response(data, status_code, pagination: nil)
    render(
      json: { status: 'success', number_of_pages: pagination }.compact
              .merge(data, message: nil),
      status: status_code
    )
  end
end
