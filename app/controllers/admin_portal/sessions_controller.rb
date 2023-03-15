class AdminPortal::SessionsController < ApplicationController

  def create
    data = {
      user: {
        "id": 1,
        "first_name": "Mariam",
        "last_name": "Youssri",
        "username": "18011769",
        "must_change_password": false,
        "role": "student",
        "auth_token": "sgasdhaejfcfjesfcoec"
      }
    }
    render(
      json: { status: "success" }.merge(data, error_message: nil),
      status: :ok
    )
  end
end
