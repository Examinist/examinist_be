Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'
  # Sidekiq route
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'examinist' && password == 'password'
  end
  mount Sidekiq::Web => '/sidekiq'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :coordinator_portal do
    resources :sessions, only: %i[create] do
      collection do
        delete :destroy
      end
    end
    resources :coordinators do
      collection do
        get :user_info
      end
    end
    resources :labs, only: %i[index create update destroy]
    resources :faculties, only: %i[index] do
      resources :staffs, only: %i[index update]
    end
  end

  namespace :staff_portal do
    resources :sessions, only: %i[create] do
      collection do
        delete :destroy
      end
    end
    resources :courses, only: %i[index show] do
      resources :course_groups, only: %i[index]
      resources :question_types, only: %i[index create update destroy]
      resources :topics, only: %i[index create update destroy]
      resources :questions, only: %i[index create update destroy]
      member do
        get :exam_template
        patch :update_exam_template
      end
    end
    resources :staffs do
      collection do
        get :user_info
      end
    end
    resources :exams, only: %i[create update index show destroy] do
      resources :student_exams, only: %i[index show update]
      collection do
        post :auto_generate
        get :sixty_minutes_exams
      end
    end
    resources :labs, only: %i[index]
    resources :schedules, only: %i[index show create update destroy]
  end

  namespace :student_portal do
    resources :sessions, only: %i[create] do
      collection do
        delete :destroy
      end
    end
    resources :courses, only: %i[index show]
    resources :students do
      collection do
        get :user_info
      end
    end
    resources :student_exams, only: %i[index show update] do
      collection do
        get :sixty_minutes_exams
      end
    end
  end
end
