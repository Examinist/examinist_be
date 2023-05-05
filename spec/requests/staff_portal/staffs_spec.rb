require 'swagger_helper'

RSpec.describe 'staff_portal/staffs_controller', type: :request do
  path '/staff_portal/staffs/user_info' do
    get 'Staff user info' do
      tags 'Staff Portal / Staff'
      description "This API is responsible for:\n
      * Getting user info from the header"

      operationId 'userInfo'
      produces 'application/json'

      security [staff_auth: []]

      response 200, 'user info returned successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/staff'
        run_test!
      end

      response 401, 'Suspicious token. Authorization failed!' do
        schema '$ref' => '#/components/errors/invalid_credentials'
        run_test!
      end
    end
  end
end
