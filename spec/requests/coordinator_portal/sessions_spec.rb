require 'swagger_helper'

RSpec.describe 'coordinator_portal/sessions_controller', type: :request do
  path '/coordinator_portal/sessions' do
    post 'Coordinator Login' do
      tags 'Coordinator Portal / Session'
      description "This API is responsible for:\n
      * Logging in the coordinator and returning:
      1)  The coordinator's object\n
      2)  The Authentication Bearer token"

      operationId 'coordinatorLogin'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string, example: 'super' },
          password: { type: :string, example: '123456' }
        },
        required: %w[username password]
      }

      response 200, 'Coordinator logged in successfully' do
        schema '$ref' => '#/components/responses/coordinator_portal/show/coordinator_session'
        run_test!
      end

      response 401, 'Invalid username or password' do
        schema '$ref' => '#/components/errors/invalid_credentials'
        run_test!
      end
    end

    delete 'Coordinator Logout' do
      tags 'Coordinator Portal / Session'
      description "This API is responsible for:\n
      * Logging out the coordinator"

      operationId 'coordinatorLogout'
      produces 'application/json'

      security [coordinator_auth: []]

      response 200, 'Coordinator logged out successfully' do
        run_test!
      end
    end
  end
end
