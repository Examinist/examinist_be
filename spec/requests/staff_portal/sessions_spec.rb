require 'swagger_helper'

RSpec.describe 'staff_portal/sessions_controller', type: :request do
  path '/staff_portal/sessions' do
    post 'Staff Login' do
      tags 'Staff Portal / Session'
      description "This API is responsible for:\n
      * Logging in the student and returning the staff's object\n
      * returning the Authentication Bearer token"

      operationId 'staffLogin'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string, example: 'marioma' },
          password: { type: :string, example: '123456' }
        },
        required: %w[username password]
      }

      response 200, 'Staff logged in successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/staff_session'
        run_test!
      end
    end
  end
end
