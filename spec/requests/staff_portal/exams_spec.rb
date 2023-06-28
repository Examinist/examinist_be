require 'swagger_helper'

RSpec.describe 'staff_portal/exams', type: :request do
  path '/staff_portal/exams' do
    get 'List Exams' do
      tags 'Staff Portal / Exam'
      description "This API is responsible for:\n
      * Listing the Exams"

      operationId 'listExams'
      produces 'application/json'

      parameter name: :filter_by_status, in: :query,
                schema: { type: :string, enum: %w[unscheduled scheduled ongoing pending_grading graded] },
                description: 'Filtering exams by status'
      parameter name: :course_id, in: :query,
                schema: { type: :integer, example: 1 },
                description: 'This is the course id given if the listing is in the course tab'
      parameter name: :order_by_pending_labs_assignment, in: :query,
                schema: { type: :string, enum: %i[desc]  },
                description: 'Ordering exams by pending labs assignment status (true elements first)'

      parameter '$ref' => '#/components/global_parameters/page_param'

      security [staff_auth: []]

      response 200, 'Course Exams Listed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/list/exams_list'
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

    post 'Create Exam' do
      tags 'Staff Portal / Exam'
      description "This API is responsible for:\n
      * Create an Exam for a specific Course"

      operationId 'createExam'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'Midterm' },
          duration: { type: :integer, example: 120 },
          is_auto: { type: :boolean, example: false },
          course_id: { type: :integer, example: 1 },
          has_models: { type: :boolean, example: false },
          exam_questions_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                question_id: { type: :integer, example: 1 },
                score: { type: :integer, example: 7 }
              }
            }
          }
        },
        required: %w[title duration is_auto course_id exam_questions_attributes]
      }

      security [staff_auth: []]

      response 201, 'Course Exam Created successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/exam'
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

  path '/staff_portal/exams/{id}' do
    get 'Show Exam' do
      tags 'Staff Portal / Exam'
      description "This API is responsible for:\n
      * View an Exam"

      operationId 'showExam'
      produces 'application/json'

      parameter name: :course_id, in: :query,
                schema: { type: :integer, example: 1 },
                description: 'This is the course id given if the listing is in the course tab'
      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 201, 'Course Exam Showed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/exam'
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

    patch 'Update Exam' do
      tags 'Staff Portal / Exam'
      description "This API is responsible for:\n
      * Update an Exam"

      operationId 'updateExam'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :course_id, in: :query,
                schema: { type: :integer, example: 1 },
                description: 'This is the course id given if the listing is in the course tab'
      parameter '$ref' => '#/components/global_parameters/id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'Final' },
          duration: { type: :integer, example: 60 },
          has_models: { type: :boolean, example: false },
          exam_questions_attributes: {
            type: :array,
            items: {
              oneOf: [
                {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 5 },
                    question_id: { type: :integer, example: 6 }
                  }
                },
                {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 5 },
                    question_id: { type: :integer, example: 7 },
                    score: { type: :integer, example: 9 }
                  }
                },
                {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 5 },
                    score: { type: :integer, example: 5 }
                  }
                },
                {
                  type: :object,
                  properties: {
                    question_id: { type: :integer, example: 10 },
                    score: { type: :integer, example: 10 }
                  }
                },
                {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 7 },
                    _destroy: { type: :boolean, example: true }
                  }
                }
              ]
            }
          }
        }
      }

      security [staff_auth: []]

      response 201, 'Course Exam Updated successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/exam'
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

    delete 'Delete Exam' do
      tags 'Staff Portal / Exam'
      description "This API is responsible for:\n
      * Delete an Exam"

      operationId 'deleteExam'
      produces 'application/json'

      parameter name: :course_id, in: :query,
                schema: { type: :integer, example: 1 },
                description: 'This is the course id given if the listing is in the course tab'
      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 201, 'Course Exam Deleted successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/exam'
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

  path '/staff_portal/exams/auto_generate' do
    post 'Generate Exam Automatically' do
      tags 'Staff Portal / Exam'
      description "This API is responsible for:\n
      * Generate an Exam Automatically for a specific Course"
  
      operationId 'autoGenerateExam'
      consumes 'application/json'
      produces 'application/json'
  
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'Midterm' },
          duration: { type: :integer, example: 60 },
          course_id: { type: :integer, example: 1 },
          has_models: { type: :boolean, example: false },
          question_type_topics: {
            type: :array,
            items: {
              type: :object,
              properties: {
                question_type_id: { type: :integer, example: 1 },
                topic_ids:{
                  type: :array,
                  items: { type: :integer },
                  example: [1, 2, 3]
                }
              }
            }
          }
        },
        required: %w[title duration course_id question_type_topics]
      }
  
      security [staff_auth: []]
  
      response 201, 'Course Exam Automatically generated successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/exam'
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

  path '/staff_portal/exams/sixty_minutes_exams' do
    get 'List 60 Minutes Exams' do
      tags 'Staff Portal / Exam'
      description "This API is responsible for:\n
      * Listing the 60 minutes Exams"

      operationId 'listSixtyMinutesExams'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/page_param'

      security [staff_auth: []]

      response 200, 'Exams Listed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/list/exams_list'
        run_test!
      end

      response 401, 'One of the following errors' do
        schema '$ref' => '#/components/errors/unauthorized'
        run_test!
      end
    end
  end
end