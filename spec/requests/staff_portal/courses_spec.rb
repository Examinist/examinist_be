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
        schema '$ref' => '#/components/responses/staff_portal/list/courses_list'
        run_test!
      end

      response 401, 'One of the following errors' do
        schema '$ref' => '#/components/errors/unauthorized'
        run_test!
      end
    end
  end

  path '/staff_portal/courses/{id}' do
    get 'Show Course Info' do
      tags 'Staff Portal / Course'
      description "This API is responsible for:\n
      * Showing the Course Info"

      operationId 'showCourse'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 200, 'Course Info Showed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/course_info'
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
