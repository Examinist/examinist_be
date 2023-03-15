Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # Swagger route
  mount Rswag::Ui::Engine => 'api-docs'
  mount Rswag::Api::Engine => 'api-docs'

  namespace :admin_portal do
    resources :sessions, only: :create
  end
end
