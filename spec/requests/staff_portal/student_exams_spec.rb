require 'swagger_helper'

RSpec.describe '/staff_portal/exams/{exam_id}/student_exams', type: :request do
  path '/staff_portal/exams/{exam_id}/student_exams' do
    get 'List Student Exams' do
      tags 'Staff Portal / Student Exams'
      description "This API is responsible for:\n
      * Listing the Student Exams"

      operationId 'listStudentExams'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/exam_id_param'
      parameter '$ref' => '#/components/global_parameters/page_param'

      parameter name: :filter_by_status, in: :query,
                schema: { type: :string, enum: %w[upcoming ongoing pending_grading graded] },
                description: 'Filtering student exams by status'

      security [staff_auth: []]

      response 200, 'Student Exams Listed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/list/student_exams_list'
        run_test!
      end

      response 401, 'One of the following errors' do
        schema '$ref' => '#/components/errors/unauthorized'
        run_test!
      end
    end
  end

  path '/staff_portal/exams/{exam_id}/student_exams/{id}' do
    get 'Show Student Exam' do
      tags 'Staff Portal / Student Exams'
      description "This API is responsible for:\n
      * Showing the Student Exam"

      operationId 'showStudentExam'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/exam_id_param'
      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 200, 'Student Exam Showed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/student_exam'
        run_test!
      end

      response 401, 'One of the following errors' do
        schema '$ref' => '#/components/errors/unauthorized'
        run_test!
      end

      response 404, 'You may have no access to this student exam or it doesnt exist' do
        schema '$ref' => '#/components/errors/not_found'
        run_test!
      end
    end

    patch 'Update Student Exam' do
      tags 'Staff Portal / Student Exams'
      description "This API is responsible for:\n
      * Update the Score of Student Exam"

      operationId 'updateStudentExam'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/exam_id_param'
      parameter '$ref' => '#/components/global_parameters/id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          student_answers_attributes: {
            type: :array,
            items: {
              properties: {
                id: { type: :bigint, example: 1 },
                score: { type: :float, example: 2.5 }
              }
            }
          }
        }
      }

      security [staff_auth: []]

      response 201, 'Student Exam Updated successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/student_exam'
        run_test!
      end

      response 401, 'One of the following errors' do
        schema '$ref' => '#/components/errors/unauthorized'
        run_test!
      end

      response 404, 'You may have no access to this student exam or it doesnt exist' do
        schema '$ref' => '#/components/errors/not_found'
        run_test!
      end
    end
  end
end
