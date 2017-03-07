Rails.application.routes.draw do
  
  get 'users/admin/index'

  root "landing#index"

	devise_for :users, :controllers => { :registrations => "devise_overrides/registrations", sessions: "users/sessions" }

  unauthenticated :user do
    get "landing/index"
  end

  resources :students
  resources :logins
  resources :student_logins
end
