require 'swagger_helper'

RSpec.describe 'staff_portal/busy_labs', type: :request do
  path '/staff_portal/busy_labs/{id}' do
    patch 'Update Busy Lab' do
      tags 'Staff Portal / Busy Labs'
      description "This API is responsible for:\n
      * Updating a Busy lab for a specific Exam (assign and unassign proctor)"

      operationId 'updateBusyLab'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :exam_id, in: :query,
                schema: { type: :integer, example: 1 }, required: true,
                description: 'This is the exam id given'

      parameter '$ref' => '#/components/global_parameters/id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          staff_id: { type: :integer, example: 3 }
        }
      }

      security [staff_auth: []]

      response 201, 'Busy Lab Updated successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/busy_lab'
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

  path '/staff_portal/busy_labs/{id}/students' do
    get 'List Students in Busy Lab' do
      tags 'Staff Portal / Busy Labs'
      description "This API is responsible for:\n
      * List Students in Busy Lab"

      operationId 'getBusyLabStudents'
      produces 'application/json'

      parameter name: :exam_id, in: :query,
                schema: { type: :integer, example: 1 }, required: true,
                description: 'This is the exam id given'

      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 201, 'List Students successfully' do
        schema '$ref' => '#/components/responses/staff_portal/list/students_list'
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

  path '/staff_portal/busy_labs/{id}/available_proctors' do
    get 'List Available Proctors for Busy Lab' do
      tags 'Staff Portal / Busy Labs'
      description "This API is responsible for:\n
      * List Available Proctors for Busy Lab"

      operationId 'getBusyLabAvailableProctors'
      produces 'application/json'

      parameter name: :exam_id, in: :query,
                schema: { type: :integer, example: 1 }, required: true,
                description: 'This is the exam id given'

      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 201, 'List Available Proctors successfully' do
        schema '$ref' => '#/components/responses/staff_portal/list/proctors_list'
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
