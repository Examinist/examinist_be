require 'swagger_helper'

RSpec.describe 'staff_portal/courses/{course_id}/questions', type: :request do
  path '/staff_portal/courses/{course_id}/questions' do
    get 'List Questions of a specific Course' do
      tags 'Staff Portal / Course Questions'
      description "This API is responsible for:\n
      * Listing the Questions of a specific Course"

      operationId 'listQuestions'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'

      parameter name: :filter_by_header, in: :query, schema: { type: :string, example: 'header' },
                description: 'Search qusetions by header'
      parameter name: :filter_by_topic_id, in: :query, schema: { type: :integer, example: 1 },
                description: 'Filter qusetions by topic id'
      parameter name: :filter_by_question_type_id, in: :query, schema: { type: :integer, example: 1 },
                description: 'Filter qusetions by question type id'
      parameter name: :filter_by_difficulty, in: :query, schema: { type: :string, enum: %w[easy medium hard], example: 'easy' },
                description: 'Filter qusetions by difficulty'

      parameter '$ref' => '#/components/global_parameters/page_param'

      security [staff_auth: []]

      response 200, 'Course Questions Listed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/list/questions_list'
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

    post 'Create Question for a specific Course' do
      tags 'Staff Portal / Course Questions'
      description "This API is responsible for:\n
      * Create a Question for a specific Course"

      operationId 'createQuestion'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          header: { type: :string, example: 'header' },
          difficulty: { type: :string, example: 'easy' },
          number_of_choices: { type: :integer, example: 4 },
          answer_type: { type: :string, enum: %w[single_answer multiple_answers text_answer pdf_answer], example: 'multiple_answers' },
          question_type_id: { type: :integer, example: 1 },
          topic_id: { type: :integer, example: 1 },
          choices_attributes: {
            type: :array,
            items: {
              oneOf: [
                {
                  type: :object,
                  properties: {
                    choice: { type: :string, example: 'choice one' }
                  },
                },
                {
                  type: :object,
                  properties: {
                    choice: { type: :string, example: 'choice two' }
                  }
                },
                {
                  type: :object,
                  properties: {
                    choice: { type: :string, example: 'choice three' }
                  }
                },
                {
                  type: :object,
                  properties: {
                    choice: { type: :string, example: 'choice four' }
                  }
                }
              ]
            }
          },
          correct_answers_attributes: {
            type: :array,
            items: {
              oneOf: [
                {
                  type: :object,
                  properties: {
                    answer: { type: :string, example: 'choice one' }
                  },
                },
                {
                  type: :object,
                  properties: {
                    answer: { type: :string, example: 'choice two' }
                  }
                }
              ]
            }
          }
        },
        required: %w[header difficulty number_of_choices answer_type question_type_id topic_id correct_answers_attributes]
      }

      security [staff_auth: []]

      response 201, 'Course Question Created successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/question'
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

  path '/staff_portal/courses/{course_id}/questions/{id}' do
    patch 'Update Question for a specific Course' do
      tags 'Staff Portal / Course Questions'
      description "This API is responsible for:\n
      * Update a Question for a specific Course"

      operationId 'updateQuestion'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'
      parameter '$ref' => '#/components/global_parameters/id_param'

      
      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          header: { type: :string, example: 'header' },
          difficulty: { type: :string, example: 'easy' },
          number_of_choices: { type: :integer, example: 4 },
          answer_type: { type: :string, enum: %w[single_answer multiple_answers text_answer pdf_answer], example: 'multiple_answers' },
          topic_id: { type: :integer, example: 1 },
          choices_attributes: {
            type: :array,
            items: {
              oneOf: [
                {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 5 },
                    choice: { type: :string, example: 'choice one modified' }
                  },
                },
                {
                  type: :object,
                  properties: {
                    choice: { type: :string, example: 'choice five' }
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
          },
          correct_answers_attributes: {
            type: :array,
            items: {
              oneOf: [
                {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 5 },
                    answer: { type: :string, example: 'choice one modifiied' }
                  },
                },
                {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 7 },
                    _destroy: { type: :boolean, example: true }
                  }
                },
                {
                  type: :object,
                  properties: {
                    answer: { type: :string, example: 'choice five' }
                  }
                }
              ]
            }
          }
        }
      }

      security [staff_auth: []]

      response 201, 'Course Question Updated successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/question'
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

    delete 'Delete Question for a specific Course' do
      tags 'Staff Portal / Course Questions'
      description "This API is responsible for:\n
      * Delete a Question for a specific Course"

      operationId 'deleteQuestion'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/course_id_param'
      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 201, 'Course Question Deleted successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/question'
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