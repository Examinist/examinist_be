Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :staff_portal do
    resources :sessions, only: %i[create destroy]
    resources :courses, only: %i[index show] do
      resources :course_groups, only: %i[index]
      resources :question_types, only: %i[index create update destroy]
    end
  end

  namespace :student_portal do
    resources :sessions, only: %i[create destroy]
    resources :courses, only: %i[index show]
  end
end
