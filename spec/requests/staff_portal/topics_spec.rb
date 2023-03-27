require 'swagger_helper'

RSpec.describe 'staff_portal/courses/{course_id}/topics', type: :request do
  path '/staff_portal/courses/{course_id}/topics' do
    get 'List Topics of a specific Course' do
      tags 'Staff Portal / Course Topics'
      description "This API is responsible for:\n
      * Listing the Topics of a specific Course"

      operationId 'listTopics'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'

      security [staff_auth: []]

      response 200, 'Course Topics Listed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/list/topics_list'
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

  path '/staff_portal/courses/{course_id}/topics' do
    post 'Create Topic for a specific Course' do
      tags 'Staff Portal / Course Topics'
      description "This API is responsible for:\n
      * Create a Topic for a specific Course"

      operationId 'createTopic'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'introduction' },
        },
        required: %w[name]
      }

      security [staff_auth: []]

      response 201, 'Course Topic Created successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/topic'
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

  path '/staff_portal/courses/{course_id}/topics/{id}' do
    patch 'Update Topic for a specific Course' do
      tags 'Staff Portal / Course Topics'
      description "This API is responsible for:\n
      * Update a Topic for a specific Course"

      operationId 'updateTopic'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'
      parameter '$ref' => '#/components/global_parameters/id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'introduction' },
        }
      }

      security [staff_auth: []]

      response 201, 'Course Topic Updated successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/topic'
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

  path '/staff_portal/courses/{course_id}/topics/{id}' do
    delete 'Delete Topic for a specific Course' do
      tags 'Staff Portal / Course Topics'
      description "This API is responsible for:\n
      * Delete a Topic for a specific Course"

      operationId 'deleteTopic'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'
      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 201, 'Course Topic Deleted successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/topic'
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
