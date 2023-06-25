require 'swagger_helper'

RSpec.describe 'coordinator_portal/faculties', type: :request do
  path '/coordinator_portal/faculties' do
    get 'List Faculties' do
      tags 'Coordinator Portal / Faculties'
      description "This API is responsible for:\n
      * Listing the University Faculties"

      operationId 'listFaculties'
      produces 'application/json'

      security [coordinator_auth: []]

      response 200, 'Faculties Listed successfully' do
      schema '$ref' => '#/components/responses/coordinator_portal/list/faculties_list'
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