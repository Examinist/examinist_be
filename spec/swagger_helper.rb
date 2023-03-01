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
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
                default: 'localhost:3000/',
            }
          }
        }
      ],
      components: {
        schemas: {
          faculty: {
            type: 'object',
            properties: {
                id: { type: 'integer' },
                faculty_name: { type: 'string', example: 'Faculty of Engineering' },
                University_name: { type: 'string', example: 'Alexandria University'},
            },
            required: %w[id faculty_name University_name]
          },
          student: {
            type: 'object',
            properties: {
                id: { type: 'integer' },
                email: { type: 'string', example: 'ahmed.gamal5551.ag@gmail.com' },
                name: { type: 'string', example: 'Jimmy'},
                faculty_id: { type: 'integer', example: 1},
                academic_id: { type: 'integer', example: 18010083}
            },
            required: %w[id email name faculty_id academic_id]
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