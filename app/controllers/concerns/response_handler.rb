module ResponseHandler
  extend ActiveSupport::Concern

  def render_response(data, status_code, pagination: nil)
    pages_count = pagination.present? ? pagination : nil
    render(
      json: { status: 'success', number_of_pages: pages_count }.compact
              .merge(data, message: nil),
      status: status_code
    )
  end
end
