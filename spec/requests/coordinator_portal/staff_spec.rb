require 'swagger_helper'

RSpec.describe 'coordinator_portal/faculties/{faculty_id}/staffs', type: :request do
  path '/coordinator_portal/faculties/{faculty_id}/staffs' do
    get 'List Staff' do
      tags 'Coordinator Portal / Staff'
      description "This API is responsible for:\n
      * Listing the Faculty Staff Instructors"

      operationId 'listStaff'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/faculty_id_param'

      security [coordinator_auth: []]

      response 200, 'Staff Listed successfully' do
      schema '$ref' => '#/components/responses/coordinator_portal/list/staffs_list'
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

  path '/coordinator_portal/faculties/{faculty_id}/staffs/{id}' do
    patch 'Update Staff' do
      tags 'Coordinator Portal / Staff'
      description "This API is responsible for:\n
      * Update Instructor to admin
      * Update admin to instructor"

      operationId 'updateStaff'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/faculty_id_param'
      parameter '$ref' => '#/components/global_parameters/id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          role: { type: :string, enum: %w[admin instructor], example: 'admin' },
        }
      }

      security [coordinator_auth: []]

      response 201, 'Faculty Staff Updated successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/staff'
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