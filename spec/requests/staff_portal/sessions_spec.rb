require 'swagger_helper'

RSpec.describe 'staff_portal/sessions_controller', type: :request do
  path '/staff_portal/sessions' do
    post 'Staff Login' do
      tags 'Staff Portal / Session'
      description "This API is responsible for:\n
      * Logging in the staff and returning the staff's object\n
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

      response 401, 'Invalid username or password' do
        schema '$ref' => '#/components/errors/invalid_credentials'
        run_test!
      end
    end

    delete 'Staff Logout' do
      tags 'Staff Portal / Session'
      description "This API is responsible for:\n
      * Logging out the staff"

      operationId 'staffLogout'
      produces 'application/json'

      security [staff_auth: []]

      response 200, 'Staff logged out successfully' do
        run_test!
      end
    end
  end
end
