require 'swagger_helper'

RSpec.describe 'coordinator_portal/labs', type: :request do
  path '/coordinator_portal/labs' do
    get 'List labs' do
      tags 'Coordinator Portal / Labs'
      description "This API is responsible for:\n
      * Listing the labs"

      operationId 'listLabs'
      produces 'application/json'

      security [coordinator_auth: []]

      response 200, 'Labs Listed successfully' do
        schema '$ref' => '#/components/responses/coordinator_portal/list/labs_list'
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

    post 'Create Lab' do
      tags 'Coordinator Portal / Labs'
      description "This API is responsible for:\n
      * Creating a Lab"

      operationId 'createLab'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Lab A' },
          capacity: { type: :integer, example: 30 }
        },
        required: %w[name capacity]
      }

      security [coordinator_auth: []]

      response 201, 'Lab Created successfully' do
        schema '$ref' => '#/components/responses/coordinator_portal/show/lab'
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

  path '/coordinator_portal/labs/{id}' do
    patch 'Update a Lab' do
      tags 'Coordinator Portal / Labs'
      description "This API is responsible for:\n
      * Updating a Lab"

      operationId 'updateLab'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Lab A' },
          capacity: { type: :integer, example: 30 }
        },
        required: %w[name capacity]
      }

      security [coordinator_auth: []]

      response 201, 'Lab Updated successfully' do
        schema '$ref' => '#/components/responses/coordinator_portal/show/lab'
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

    delete 'Delete Lab' do
      tags 'Coordinator Portal / Labs'
      description "This API is responsible for:\n
      * Deleting a Lab"

      operationId 'deleteLab'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/id_param'

      security [coordinator_auth: []]

      response 201, 'Lab Deleted successfully' do
        schema '$ref' => '#/components/responses/coordinator_portal/show/lab'
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