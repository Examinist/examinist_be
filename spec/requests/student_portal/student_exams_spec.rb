require 'swagger_helper'

RSpec.describe 'student_portal/student_exams', type: :request do
  path '/student_portal/student_exams' do
    get 'List Student Exams' do
      tags 'Student Portal / Student Exams'
      description "This API is responsible for:\n
      * Listing the Student Exams"

      operationId 'listStudentExams'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/page_param'

      parameter name: :filter_by_status, in: :query,
                schema: { type: :string, enum: %w[upcoming ongoing pending_grading graded] },
                description: 'Filtering exams by status'

      security [student_auth: []]

      response 200, 'Student Exams Listed successfully' do
        schema '$ref' => '#/components/responses/student_portal/list/student_exams_list'
        run_test!
      end

      response 401, 'One of the following errors' do
        schema '$ref' => '#/components/errors/unauthorized'
        run_test!
      end
    end
  end

  path '/student_portal/student_exams/sixty_minutes_exams' do
    get 'List 60 Minutes Student Exams' do
      tags 'Student Portal / Student Exams'
      description "This API is responsible for:\n
      * Listing the 60 minutes Student Exams"

      operationId 'listSixtyMinutesStudentExams'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/page_param'

      security [student_auth: []]

      response 200, 'Student Exams Listed successfully' do
        schema '$ref' => '#/components/responses/student_portal/list/student_exams_list'
        run_test!
      end

      response 401, 'One of the following errors' do
        schema '$ref' => '#/components/errors/unauthorized'
        run_test!
      end
    end
  end
end
