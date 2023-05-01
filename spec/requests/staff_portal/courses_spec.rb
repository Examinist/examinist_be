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

  path '/staff_portal/courses/{id}/exam_template' do
    get 'Show Course Exam Template' do
      tags 'Staff Portal / Course'
      description "This API is responsible for:\n
      * Showing the Course Exam Template"

      operationId 'showCourseExamTemplate'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 200, 'Course Exam Template Showed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/exam_template'
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

  path '/staff_portal/courses/{id}/update_exam_template' do
    patch 'Update Course Exam Template' do
      tags 'Staff Portal / Course'
      description "This API is responsible for:\n
      * Updating the Course Exam Template"

      operationId 'updateCourseExamTemplate'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          easy: { type: :float, example: 70 },
          medium: { type: :float, example: 25 },
          hard: { type: :float, example: 5 },
          question_types_attributes: { 
            type: :array,
            items: {
              properties: {
                id: { type: :bigint, example: 1 },
                ratio: { type: :float, example: 25 }
              }
            }
          }
        }
      }

      security [staff_auth: []]

      response 200, 'Course Exam Template Updated successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/exam_template'
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
