require 'swagger_helper'

RSpec.describe 'staff_portal/courses/{course_id}/question_types', type: :request do
  path '/staff_portal/courses/{course_id}/question_types' do
    get 'List Question Types of a specific Course' do
      tags 'Staff Portal / Question Types'
      description "This API is responsible for:\n
      * Listing the Question Types of a specific Course"

      operationId 'listQuestionTypes'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'

      security [staff_auth: []]

      response 200, 'Question Types Listed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/list/question_types'
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

    post 'Create Question Types for a specific Course' do
      tags 'Staff Portal / Question Types'
      description "This API is responsible for:\n
      * Creating a Question Type for a specific Course"

      operationId 'createQuestionTYpe'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Modeling' },
          easy_weight: { type: :integer, example: 1 },
          medium_weight: { type: :integer, example: 2 },
          hard_weight: { type: :integer, example: 3}
        },
        required: %w[name]
      }

      security [staff_auth: []]

      response 201, 'Question Type Created successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/question_type'
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

      response 422, 'attribute already taken for question types in this course' do
        schema '$ref' => '#/components/errors/already_taken'
        run_test!
      end
    end
  end

  path '/staff_portal/courses/{course_id}/question_types/{id}' do
    patch 'Update Question Type for a specific Course' do
      tags 'Staff Portal / Question Types'
      description "This API is responsible for:\n
      * Updating a Question Type for a specific Course"

      operationId 'updateQuestionType'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'
      parameter '$ref' => '#/components/global_parameters/id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Modeling' },
          easy_weight: { type: :integer, example: 1 },
          medium_weight: { type: :integer, example: 2 },
          hard_weight: { type: :integer, example: 3}
        }
      }

      security [staff_auth: []]

      response 201, 'Question Type Updated successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/question_type'
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

      response 400, 'Name can not be changed as it is a default question type' do
        schema '$ref' => '#/components/errors/bad_request'
        run_test!
      end
    end

    delete 'Delete Question Type for a specific Course' do
      tags 'Staff Portal / Question Types'
      description "This API is responsible for:\n
      * Deleting a Question Type for a specific Course"

      operationId 'deleteQuestionType'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'
      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 201, 'Question Type Deleted successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/question_type'
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

      response 400, 'You can not delete default question types' do
        schema '$ref' => '#/components/errors/bad_request'
        run_test!
      end
    end
  end
end
