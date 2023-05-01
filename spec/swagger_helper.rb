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
          }
        },
        schemas: {
          faculty: {
            type: 'object',
            properties: {
                id: { type: 'integer', example: 1 },
                faculty_name: { type: 'string', example: 'Faculty of Engineering' },
                University_name: { type: 'string', example: 'Alexandria University'},
            },
            required: %w[id faculty_name University_name]
          },
          detailed_student: {
            type: 'object',
            properties: {
                id: { type: 'integer', example: 1 },
                email: { type: 'string', example: 'ahmed.gamal5551.ag@gmail.com' },
                first_name: { type: 'string', example: 'Ahmed'},
                last_name: { type: 'string', example: 'Gamal' },
                username: { type: 'string', example: '18010083' },
                faculty_id: { type: 'integer', example: 1},
                academic_id: { type: 'string', example: '18010083'}
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
                faculty_id: { type: 'integer', example: 1},
                role: { type: 'string', example: 'instructor'}
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
              }
            },
            list: {
              courses_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
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
                  topic: { '$ref' => '#/components/schemas/topic' },
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
              exam_template:{
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
              }
            },
            list: {
              courses_list: {
                type: :object,
                properties: {
                  status: { type: :string, example: 'success' },
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
                  topic: { 
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
