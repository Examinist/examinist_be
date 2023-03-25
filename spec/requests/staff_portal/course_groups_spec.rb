require 'swagger_helper'

RSpec.describe 'staff_portal/courses/{course_id}/course_groups', type: :request do
  path '/staff_portal/courses/{course_id}/course_groups' do
    get 'List Course Groups of a specific Course' do
      tags 'Staff Portal / Course Group'
      description "This API is responsible for:\n
      * Listing the Course Groups of a specific Course"

      operationId 'listCourseGroups'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'

      security [staff_auth: []]

      response 200, 'Course Groups Listed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/list/course_groups_list'
        run_test!
      end

      response 401, 'One of the following errors' do
        schema '$ref' => '#/components/errors/unauthorized'
        run_test!
      end

      response 404, 'You may have no access to this course or it doesnt exist' do
        schema '$ref' => '#/components/errors/not_found'
        run_test!
      end
    end
  end
end
