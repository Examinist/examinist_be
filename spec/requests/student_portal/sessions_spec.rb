require 'swagger_helper'

RSpec.describe 'student_portal/sessions_controller', type: :request do
  path '/student_portal/sessions' do
    post 'Student Login' do
      tags 'Student Portal / Session'
      description "This API is responsible for:\n
      * Logging in the student and returning the student's object\n
      * returning the Authentication Bearer token"

      operationId 'studentLogin'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          username: { type: :string, example: '18011769' },
          password: { type: :string, example: '123456' }
        },
        required: %w[username password]
      }

      response 200, 'Student logged in successfully' do
        schema '$ref' => '#/components/responses/student_portal/show/student_session'
        run_test!
      end

      response 401, 'Invalid username or password' do
        schema '$ref' => '#/components/errors/invalid_credentials'
        run_test!
      end
    end
  end
end
