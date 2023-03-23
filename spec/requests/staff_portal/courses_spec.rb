require 'swagger_helper'

RSpec.describe 'staff_portal/courses', type: :request do
  path '/staff_portal/courses' do
    get 'List Courses' do
      tags 'Staff Portal / Course'
      description "This API is responsible for:\n
      * Listing the Courses"

      operationId 'listCourses'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/page_param'

      security [staff_auth: []]

      response 200, 'Courses Listed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/courses_list'
        run_test!
      end

      response 401, 'One of the following errors' do
        schema '$ref' => '#/components/errors/unauthorized'
        run_test!
      end
    end
  end
end
