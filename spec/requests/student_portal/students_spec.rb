require 'swagger_helper'

RSpec.describe 'student_portal/students_controller', type: :request do
  path '/student_portal/students/user_info' do
    get 'Student user info' do
      tags 'Student Portal / Student'
      description "This API is responsible for:\n
      * Getting user info from the header"

      operationId 'userInfo'
      produces 'application/json'

      security [staff_auth: []]

      response 200, 'user info returned successfully' do
        schema '$ref' => '#/components/responses/student_portal/show/student'
        run_test!
      end

      response 401, 'Suspicious token. Authorization failed!' do
        schema '$ref' => '#/components/errors/invalid_credentials'
        run_test!
      end
    end
  end
end
