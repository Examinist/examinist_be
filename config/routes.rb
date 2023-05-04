Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :staff_portal do
    resources :sessions, only: %i[create destroy]
    resources :courses, only: %i[index show] do
      resources :course_groups, only: %i[index]
      resources :question_types, only: %i[index create update destroy]
      resources :topics, only: %i[index create update destroy]
      resources :questions, only: %i[index create update destroy]
    end
    resources :staffs do
      collection do
        get :user_info
      end
    end
  end

  namespace :student_portal do
    resources :sessions, only: %i[create destroy]
    resources :courses, only: %i[index show]
    resources :students do
      collection do
        get :user_info
      end
    end
  end
end
