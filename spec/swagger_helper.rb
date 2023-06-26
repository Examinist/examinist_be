# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Examinist API',
        version: 'v1',
        description: 'This is Examinist API documentation'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          variables: {
            defaultHost: {
                default: 'localhost:3000/',
            }
          }
        }
      ],
      components: {
        securitySchemes: {
          coordinator_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT
          },
          staff_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT
          },
          student_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: :JWT
          }
        },
        global_parameters: {
          id_param: {
            name: 'id',
            in: :path,
            description: 'The id to fetch with',
            required: true,
            schema: {
              type: :number,
              example: 1
            }
          },
          page_param: {
            name: 'page',
            in: :query,
            description: 'The current page for paginated items, send it with value = -1 if no pagination needed',
            schema: {
              type: :number,
              example: -1
            }
          },
          course_id_param: {
            name: 'course_id',
            in: :path,
            description: 'The course id to fetch with',
            required: true,
            schema: {
              type: :number,
              example: 1
            }
          },
          exam_id_param: {
            name: 'exam_id',
            in: :path,
            description: 'The exam id to fetch with',
            required: true,
            schema: {
              type: :number,
              example: 1
            }
          },
          faculty_id_param: {
            name: 'faculty_id',
            in: :path,
            description: 'The faculty id to fetch with',
            required: true,
            schema: {
              type: :number,
              example: 1
            }
          }
        },
        schemas: {
          university: {
            type: 'object',
            properties: {
              id: { type: 'integer', example: 1 },
              name: { type: 'string', example: 'Alexandria University' }
            },
            required: %w[id name]
          },
          lab: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'Lab A' },
              capacity: { type: :integer, example: 30 }
            },
            required: %w[id name capacity]
          },
          busy_lab: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'Lab A' }
            },
            required: %w[id name]
          },
          detailed_lab: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'Lab A' },
              capacity: { type: :integer, example: 30 },
              university: { '$ref' => '#/components/schemas/university' }
            },
            required: %w[id name capacity university]
          },
          faculty: {
            type: 'object',
            properties: {
                id: { type: 'integer', example: 1 },
                faculty_name: { type: 'string', example: 'Faculty of Engineering' },
                university: { '$ref' => '#/components/schemas/university' }
            },
            required: %w[id faculty_name university]
          },
          coordinator: {
            type: 'object',
            properties: {
              id: { type: 'integer', example: 1 },
              username: { type: 'string', example: 'super' },
              email: { type: 'string', example: 'ahmed.gamal5551.ag@gmail.com' },
              role: { type: :string, example: 'university_admin' },
              university: { '$ref' => '#/components/schemas/university' }
            },
            required: %w[id username email university]
          },
          coordinator_session: {
            type: 'object',
            properties: {
              id: { type: 'integer', example: 1 },
              username: { type: 'string', example: 'super' },
              email: { type: 'string', example: 'ahmed.gamal5551.ag@gmail.com' },
              role: { type: :string, example: 'university_admin' },
              university: { '$ref' => '#/components/schemas/university' },
              auth_token: { type: :string, example: "hgcscxmopjsecohsecophopshcijsic" }
            },
            required: %w[id username email university auth_token]
          },
          detailed_student: {
            type: 'object',
            properties: {
                id: { type: 'integer', example: 1 },
                email: { type: 'string', example: 'ahmed.gamal5551.ag@gmail.com' },
                first_name: { type: 'string', example: 'Ahmed'},
                last_name: { type: 'string', example: 'Gamal' },
                username: { type: 'string', example: '18010083' },
                role: { type: :string, example: 'student' },
                academic_id: { type: 'string', example: '18010083' },
                faculty: { '$ref' => '#/components/schemas/faculty' }
            },
            required: %w[id email first_name last_name username faculty_id academic_id]
          },
          student: {
            type: 'object',
            properties: {
                id: { type: 'integer', example: 1 },
                first_name: { type: 'string', example: 'Ahmed'},
                last_name: { type: 'string', example: 'Gamal' },
                username: { type: 'string', example: '18010083' },
                role: { type: :string, example: 'student' }
            },
            required: %w[id first_name last_name username role]
          },
          student_session: {
            type: 'object',
            properties: {
                id: { type: 'integer', example: 1 },
                first_name: { type: :string , example: 'Ahmed'},
                last_name: { type: :string, example: 'Gamal' },
                username: { type: :string, example: '18010083' },
                role: { type: :string, example: 'student' },
                auth_token: { type: :string, example: "hgcscxmopjsecohsecophopshcijsic" }
            },
            required: %w[id first_name last_name username role auth_token]
          },
          detailed_staff: {
            type: 'object',
            properties: {
                id: { type: 'integer', example: 1 },
                email: { type: 'string', example: 'ahmed.gamal5551.ag@gmail.com' },
                first_name: { type: 'string', example: 'Ahmed'},
                last_name: { type: 'string', example: 'Gamal' },
                username: { type: 'string', example: 'jimmy' },
                role: { type: 'string', example: 'instructor'},
                faculty: { '$ref' => '#/components/schemas/faculty'  }
            },
            required: %w[id email first_name last_name username faculty_id role]
          },
          staff: {
            type: 'object',
            properties: {
                id: { type: 'integer', example: 1 },
                first_name: { type: 'string', example: 'Ahmed' },
                last_name: { type: 'string', example: 'Gamal' },
                username: { type: 'string', example: 'jimmy' },
                role: { type: 'string', example: 'instructor' }
            },
            required: %w[id first_name last_name username role]
          },
          staff_session: {
            type: 'object',
            properties: {
                id: { type: 'integer', example: 1 },
                first_name: { type: 'string', example: 'Ahmed'},
                last_name: { type: 'string', example: 'Gamal' },
                username: { type: 'string', example: 'jimmy' },
                role: { type: 'string', example: 'instructor'},
                auth_token: { type: :string, example: "hgcscxmopjsecohsecophopshcijsic" }
            },
            required: %w[id first_name last_name username role auth_token]
          },
          coordinator_staff: {
            type: 'object',
            properties: {
                id: { type: 'integer', example: 1 },
                first_name: { type: 'string', example: 'Ahmed' },
                last_name: { type: 'string', example: 'Gamal' },
                username: { type: 'string', example: 'jimmy' }
            },
            required: %w[id first_name last_name username]
          },
          course: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              title: { type: :string, example: 'Database' },
              code: { type: :string, example: 'CSE512' }
            },
            required: %w[id title code]
          },
          course_group: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'Group A' },
              end_date: { type: :date_time, example: '2023-03-25T09:25:25.551Z' },
              instructors: {
                type: :array,
                items: { '$ref' => '#/components/schemas/staff' }
              },
              students: {
                type: :array,
                items: { '$ref' => '#/components/schemas/student' }
              }
            },
            required: %w[id end_date instructors students]
          },
          detailed_course_info: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              title: { type: :string, example: 'Database' },
              code: { type: :string, example: 'CSE512' },
              credit_hours: { type: :integer, example: 3 },
              instructors: {
                type: :array,
                items: { '$ref' => '#/components/schemas/staff' }
              },
              students: {
                type: :array,
                items: { '$ref' => '#/components/schemas/student' }
              }
            },
            required: %w[id title code credit_hours instructors students]
          },
          topic: { 
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'Introduction' },
            },
            required: %w[id name]
          },
          detailed_topic: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'Introduction' },
              course: { '$ref' => '#/components/schemas/course' }
            },
            required: %w[id name course]
          },
          question_type: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'MCQ' },
              easy_weight: { type: :integer, example: 1 },
              medium_weight: { type: :integer, example: 2 },
              hard_weight: { type: :integer, example: 3 },
              is_deletable:{ type: :boolean, example: false},
              ratio: { type: :float, example: 25 }
            }
          },
          exam_template: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              easy: { type: :float, example: 60.0 },
              medium: { type: :float, example: 30.0 },
              hard: { type: :float, example: 10.0 },
              question_types: {
                type: :array,
                items: { '$ref' => '#/components/schemas/question_type' }
              },
              course: { '$ref' => '#/components/schemas/course' }
            }
          },
          choice: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              choice: { type: :string, example: 'choice' },
              is_answer: { type: :boolean, example: true }
            },
            required: %w[id choice is_answer]
          },
          correct_answer: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              answer: { type: :string, example: 'answer' },
              choice_id: { type: :integer, example: 1 }
            },
            required: %w[id choice]
          },
          question: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              header: { type: :string, example: 'header' },
              difficulty: { type: :string, enum: %w[easy medium hard], example: 'easy' },
              answer_type: { type: :string, enum: %w[single_answer multiple_answers text_answer pdf_answer], example: 'multiple_answers'},
              question_type: { '$ref' => '#/components/schemas/question_type' },
              topic: { '$ref' => '#/components/schemas/topic' },
              choices: {
                type: :array,
                items: { '$ref' => '#/components/schemas/choice' }
              },
              correct_answers: {
                type: :array,
                items: { '$ref' => '#/components/schemas/correct_answer' }
              }
            },
            required: %w[id header difficulty answer_type question_type topic choices correct_answers]
          },
          detailed_question: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              header: { type: :string, example: 'header' },
              difficulty: { type: :string, enum: %w[easy medium hard], example: 'easy' },
              answer_type: { type: :string, enum: %w[single_answer multiple_answers text_answer pdf_answer], example: 'multiple_answers'},
              question_type: { '$ref' => '#/components/schemas/question_type' },
              topic: { '$ref' => '#/components/schemas/topic' },
              choices: {
                type: :array,
                items: { '$ref' => '#/components/schemas/choice' }
              },
              correct_answers: {
                type: :array,
                items: { '$ref' => '#/components/schemas/correct_answer' }
              },
              course: { '$ref' => '#/components/schemas/course' }
            },
            required: %w[id header difficulty answer_type question_type topic choices correct_answers course]
          },
          exam: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              title: { type: :string, example: 'Midterm' },
              status: { type: :string, enum: %w[unscheduled scheduled ongoing pending_grading graded], example: 'unscheduled' },
              duration: { type: :integer, example: 120 },
              total_score: { type: :integer, example: 40 },
              has_models: { type: :boolean, example: false },
              created_at: { type: :datetime, example: '2023-04-06T12:38:03.081+03:00' },
              scheduled_date: { type: :datetime, example: '2023-04-26T12:38:03.081+03:00' },
              creation_mode: { type: :string, example: 'Manual' },
              creator: { '$ref' => '#/components/schemas/staff' },
              course: { '$ref' => '#/components/schemas/course' },
              number_of_students: { type: :integer, example: 40 },
              busy_labs: {
                type: :array,
                items: { '$ref' => '#/components/schemas/busy_lab' }
              }
            },
            required: %w[id title status duration total_score created_at scheduled_date creation_mode creator course]
          },
          detailed_exam: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              title: { type: :string, example: 'Midterm' },
              status: { type: :string, enum: %w[unscheduled scheduled ongoing pending_grading graded], example: 'unscheduled' },
              duration: { type: :integer, example: 120 },
              total_score: { type: :integer, example: 40 },
              has_models: { type: :boolean, example: false },
              created_at: { type: :datetime, example: '2023-04-06T12:38:03.081+03:00' },
              scheduled_date: { type: :datetime, example: '2023-04-26T12:38:03.081+03:00' },
              creation_mode: { type: :string, example: 'Manual' },
              creator: { '$ref' => '#/components/schemas/staff' },
              course: { '$ref' => '#/components/schemas/course' },
              number_of_students: { type: :integer, example: 40 },
              busy_labs: {
                type: :array,
                items: { '$ref' => '#/components/schemas/busy_lab' }
              },
              exam_questions: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    mcq: {
                      type: :array,
                      items: { '$ref' => '#/components/schemas/exam_question' }
                    }
                  }
                }
              }
            },
            required: %w[id title status duration total_score created_at scheduled_date creation_mode creator course exam_questions]
          },
          exam_question: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              score: { type: :integer, example: 22 },
              question: { '$ref' => '#/components/schemas/question' }
            },
            required: %w[id score question]
          },
          schedule: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              title: { type: :string, example: 'CSED-Midterm' }
            },
            required: %w[id title]
          },
          detailed_schedule: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              title: { type: :string, example: 'CSED-Midterm' },
              exams: {
                type: :array,
                items: { '$ref' => '#/components/schemas/exam' }
              }
            },
            required: %w[id title exams]
          },
          student_portal_student_exam: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              grade: { type: :float, example: 50 },
              status: { type: :string, enum: %w[upcoming ongoing pending_grading graded], example: 'upcoming' },
              title: { type: :string, example: 'Midterm' },
              total_score: { type: :integer, example: 40 },
              scheduled_date: { type: :datetime, example: '2023-04-26T12:38:03.081+03:00' },
              ends_at: { type: :datetime, example: '2023-04-26T14:38:03.081+03:00' },
              duration: { type: :integer, example: 120 },
              course: { '$ref' => '#/components/schemas/course' },
              busy_lab: {'$ref' => '#/components/schemas/busy_lab' }
            }
          },
          student_portal_question_type: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'MCQ' }
            }
          },
          student_portal_choice: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              choice: { type: :string, example: 'choice' }
            },
            required: %w[id choice]
          },
          student_portal_question: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              header: { type: :string, example: 'header' },
              difficulty: { type: :string, enum: %w[easy medium hard], example: 'easy' },
              answer_type: { type: :string, enum: %w[single_answer multiple_answers text_answer pdf_answer], example: 'multiple_answers'},
              question_type: { '$ref' => '#/components/schemas/student_portal_question_type' },
              topic: { '$ref' => '#/components/schemas/topic' },
              choices: {
                type: :array,
                items: { '$ref' => '#/components/schemas/student_portal_choice' }
              }
            },
            required: %w[id header difficulty answer_type question_type topic choices]
          },
          student_portal_student_answer: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              answers: {
                type: :array,
                items: { type: :string },
                example: ['choice_one', 'choice_two']
              },
              marked: { type: :boolean, example: true },
              solved: { type: :boolean, example: false },
              question: { '$ref' => '#/components/schemas/student_portal_question' }
            }
          },
          student_portal_detailed_student_exam: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              grade: { type: :float, example: 50 },
              status: { type: :string, enum: %w[upcoming ongoing pending_grading graded], example: 'upcoming' },
              title: { type: :string, example: 'Midterm' },
              total_score: { type: :integer, example: 40 },
              scheduled_date: { type: :datetime, example: '2023-04-26T12:38:03.081+03:00' },
              ends_at: { type: :datetime, example: '2023-04-26T14:38:03.081+03:00' },
              duration: { type: :integer, example: 120 },
              course: { '$ref' => '#/components/schemas/course' },
              busy_lab: { '$ref' => '#/components/schemas/busy_lab' },
              answers: { '$ref' => '#/components/schemas/student_portal_student_answer' }
            }
          },
          student_exam: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              status: { type: :string, enum: %w[upcoming ongoing pending_grading graded], example: 'upcoming' },
              student_status: { type: :string, example: 'Attended' },
              total_score: { type: :integer, example: 40 },
              partial_score: { type: :integer, example: 25 },
              total_graded_questions: { type: :integer, example: 10 },
              partial_graded_questions: { type: :integer, example: 5 },
              student: { '$ref' => '#/components/schemas/detailed_student' }
            }
          },
          university_faculty: {
            type: 'object',
            properties: {
              id: { type: :integer, example: 1 },
              faculty_name: { type: :string, example: "Faculty of Engineering" },
              admins: { 
                type: :array,
                items: { '$ref' => '#/components/schemas/coordinator_staff' }
              }
            }
          }
        },
        errors: {
          invalid_credentials: {
            type: :object,
            properties:
            {
              status: { type: 'string', example: 'error' },
              message: { type: 'string', example: 'Invalid credentials' }
            }
          },
          not_found: {
            type: :object,
            properties:
            {
              status: { type: 'string', example: 'error' },
              message: { type: 'string', example: 'Unfortunately this course does not exist or you do not have permissions to access' }
            }
          },
          unauthorized: {
            type: :array,
            items:
            {
              type: :object,
              properties: {
                status: { type: 'string', example: 'error' },
                message: { type: 'string', example: 'Invalid credentials' }
              }
            },
            example:
            [
              {
                status: 'error',
                message: 'Invalid Credentials'
              },
              {
                status: 'error',
                message: 'Unauthorized action!'
              }
            ]
          },
          already_taken: {
            type: :object,
            properties:
            {
              status: { type: 'string', example: 'error' },
              message: { type: 'string', example: 'Name has already been taken' }
            }
          },
          bad_request: {
            type: :object,
            properties:
            {
              status: { type: 'string', example: 'error' },
              message: { type: 'string', example: 'Bad Request, Error message mentioned above' }
            }
          }
        },
        responses: {
          coordinator_portal: {
            show: {
              coordinator_session: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  coordinator: { '$ref' => '#/components/schemas/coordinator_session' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              coordinator: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  coordinator: { '$ref' => '#/components/schemas/coordinator' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              lab: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  lab: { '$ref' => '#/components/schemas/detailed_lab' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              staff: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  staff: { '$ref' => '#/components/schemas/coordinator_staff' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              }
            },
            list: {
              labs_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  labs: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/lab' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              faculties_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  faculties: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/university_faculty' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              staffs_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  staffs: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/coordinator_staff' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              }
            }
          },
          student_portal: {
            show: {
              student_session: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  student: { '$ref' => '#/components/schemas/student_session' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              course_info: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  course_info: { '$ref' => '#/components/schemas/detailed_course_info' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              student: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  student: { '$ref' => '#/components/schemas/student' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              student_exam: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  student_exam: { '$ref' => '#/components/schemas/student_portal_detailed_student_exam' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              }
            },
            list: {
              courses_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  number_of_pages: { type: :integer, example: 4 },
                  courses: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/course' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              student_exams_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  number_of_pages: { type: :integer, example: 4 },
                  student_exams: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/student_portal_student_exam' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              }
            }
          },
          staff_portal: {
            show: {
              staff_session: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  student: { '$ref' => '#/components/schemas/staff_session' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              course_info: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  course_info: { '$ref' => '#/components/schemas/detailed_course_info' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              topic: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  topic: { '$ref' => '#/components/schemas/detailed_topic' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              question_type: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  question_type: { '$ref' => '#/components/schemas/question_type' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              question: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  question: { '$ref' => '#/components/schemas/detailed_question' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              exam: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  exam: { '$ref' => '#/components/schemas/detailed_exam' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              exam_template: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  exam_template: { '$ref' => '#/components/schemas/exam_template' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              staff: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  student: { '$ref' => '#/components/schemas/staff' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              schedule: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  schedule: { '$ref' => '#/components/schemas/detailed_schedule' },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              }
            },
            list: {
              courses_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  number_of_pages: { type: :integer, example: 4 },
                  courses: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/course' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              course_groups_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  course_groups: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/course_group' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              topics_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  topics: { 
                    type: :array,
                    items: { '$ref' => '#/components/schemas/topic' } 
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              question_types: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  question_types: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/question_type' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              questions_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  number_of_pages: { type: :integer, example: 4 },
                  questions: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/question' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              exams_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  number_of_pages: { type: :integer, example: 4 },
                  exams: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/exam' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              labs_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  labs: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/lab' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              schedules_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  schedules: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/schedule' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              },
              student_exams_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
                  number_of_pages: { type: :integer, example: 4 },
                  student_exams: {
                    type: :array,
                    items: { '$ref' => '#/components/schemas/student_exam' }
                  },
                  message: {
                    type: :string,
                    description: 'This message is the error message in case of status: "error" otherwise it is null',
                    example: nil
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
