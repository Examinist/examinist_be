require 'swagger_helper'

RSpec.describe 'staff_portal/schedules', type: :request do
  path '/staff_portal/schedules' do
    get 'List Schedules' do
      tags 'Staff Portal / Schedule'
      description "This API is responsible for:\n
      * Listing the Schedules"

      operationId 'listSchedules'
      produces 'application/json'

      security [staff_auth: []]

      response 200, 'Schedules Listed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/list/schedules_list'
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

    post 'Create Schedule' do
      tags 'Staff Portal / Schedule'
      description "This API is responsible for:\n
      * Create a Schedule"

      operationId 'createSchedule'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'CSED-Midterm' },
          exams: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, example: 1 },
                starts_at: { type: :datetime, example: '2023-06-06T12:38:03.081+03:00' },
                _force: { type: :boolean, example: false },
                busy_labs_attributes: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      lab_id: { type: :integer, example: 1 }
                    }
                  }
                }
              }
            }
          }
        },
        required: %w[title exams]
      }

      security [staff_auth: []]

      response 201, 'Schedule Created successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/schedule'
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

  path '/staff_portal/schedules/{id}' do
    get 'Show Schedule' do
      tags 'Staff Portal / Schedule'
      description "This API is responsible for:\n
      * View a Schedule"

      operationId 'showSchedule'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 201, 'Schedule Showed successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/schedule'
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

    patch 'Update Schedule' do
      tags 'Staff Portal / Schedule'
      description "This API is responsible for:\n
      * Update a Schedule"

      operationId 'updateSchedule'
      consumes 'application/json'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/id_param'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'CSED-Final' },
          exams_attributes: {
            type: :array,
            items: {
              oneOf: [
                {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 1 },
                    starts_at: { type: :datetime, example: '2023-06-06T12:38:03.081+03:00' },
                    _force: { type: :boolean, example: false },
                    busy_labs_attributes: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          lab_id: { type: :integer, example: 1 }
                        }
                      }
                    }
                  }
                },
                {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 1 },
                    starts_at: { type: :datetime, example: '2023-06-06T12:38:03.081+03:00' },
                    _force: { type: :boolean, example: false },
                    busy_labs_attributes: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          id: { type: :integer, example: 5 },
                          lab_id: { type: :integer, example: 6 }
                        }
                      }
                    }
                  }
                },
                {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 1 },
                    starts_at: { type: :datetime, example: '2023-06-06T12:38:03.081+03:00' },
                    _force: { type: :boolean, example: false },
                    busy_labs_attributes: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          id: { type: :integer, example: 5 },
                          _destroy: { type: :boolean, example: true }
                        }
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      }

      security [staff_auth: []]

      response 201, 'Schedule Updated successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/schedule'
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

    delete 'Delete Schedule' do
      tags 'Staff Portal / Schedule'
      description "This API is responsible for:\n
      * Delete a Schedule"

      operationId 'deleteSchedule'
      produces 'application/json'

      parameter '$ref' => '#/components/global_parameters/id_param'

      security [staff_auth: []]

      response 201, 'Schedule Deleted successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/schedule'
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

  path '/staff_portal/schedules/auto_generate' do
    post 'Generate Schedule' do
      tags 'Staff Portal / Schedule'
      description "This API is responsible for:\n
      * Automatically generating a Schedule"

      operationId 'generateSchedule'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :payload, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'CSED-Midterm' },
          schedule_from: { type: :string, example: '01-07-2023' },
          schedule_to: { type: :string, example: '13-07-2023' },
          exam_starting_time: { type: :string, example: '10:00' , description: 'This is a 24H format of the time'},
          exam_ids: { 
            type: :array,
            items: {
              type: :integer,
              example: 1
            }
          },
          lab_ids: {
            type: :array,
            items: {
              type: :integer,
              example: 1
            }
          },
          holiday_dates: {
            type: :array,
            items: {
              type: :string,
              example: '05-07-2023'
            }
          },
          exam_week_days: {
            type: :array,
            items: {
              type: :string,
              example: 'wednesday'
            }
          }
        },
        required: %w[title schedule_from schedule_to exam_starting_time exam_ids lab_ids holiday_dates exam_week_days]
      }

      security [staff_auth: []]

      response 201, 'Schedule Generated successfully' do
        schema '$ref' => '#/components/responses/staff_portal/show/auto_schedule'
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
