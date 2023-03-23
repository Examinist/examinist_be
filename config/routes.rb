Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :staff_portal do
    resources :sessions, only: %i[create destroy]
    resources :courses, only: %i[index]
  end

  namespace :student_portal do
    resources :sessions, only: %i[create destroy]
  end
end
