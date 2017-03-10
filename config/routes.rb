Rails.application.routes.draw do
  
  get 'users/admin/index'

  root "landing#index"

	devise_for :users, :controllers => { :registrations => "devise_overrides/registrations", sessions: "users/sessions" }

  unauthenticated :user do
    get "landing/index"
  end

  get 'settings/index'

  resources :students do
  	match "/profile" => "students#profile", as: :profile, via: [:get], on: :member
  	match "/usages" => "students#usages", as: :usages, via: [:get], on: :member
  end
  resources :logins
  resources :student_logins
  resources :alloted_times
  resources :users
end
