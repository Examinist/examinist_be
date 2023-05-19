require 'swagger_helper'

RSpec.describe 'coordinator_portal/coordinators_controller', type: :request do
  path '/coordinator_portal/coordinators/user_info' do
    get 'Coordinator user info' do
      tags 'Coordinator Portal / Coordinator'
      description "This API is responsible for:\n
      * Getting user info from the header"

      operationId 'userInfo'
      produces 'application/json'

      security [coordinator_auth: []]

      response 200, 'user info returned successfully' do
        schema '$ref' => '#/components/responses/coordinator_portal/show/coordinator'
        run_test!
      end

      response 401, 'Suspicious token. Authorization failed!' do
        schema '$ref' => '#/components/errors/invalid_credentials'
        run_test!
      end
    end
  end
end
