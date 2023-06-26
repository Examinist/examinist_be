require 'swagger_helper'

RSpec.describe 'staff_portal/labs', type: :request do
  path '/staff_portal/labs' do
    get 'List labs' do
      tags 'Staff Portal / Labs'
      description "This API is responsible for:\n
      * Listing the labs"

      operationId 'listLabs'
      produces 'application/json'

      security [staff_auth: []]

      response 200, 'Labs Listed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/list/labs_list'
        run_test!
      end

      response 401, 'One of the following errors' do
        schema '$ref' => '#/components/errors/unauthorized'
        run_test!
      end

      response 404, 'You may have no access to this item or it doesnt exist' do
        schema '$ref' => '#/components/errors/not_found'
        run_test!
      end
    end
  end
end
