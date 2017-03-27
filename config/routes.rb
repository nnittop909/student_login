Rails.application.routes.draw do

  root "landing#index"

	devise_for :users, :controllers => { :registrations => "devise_overrides/registrations", sessions: "users/sessions" }

  unauthenticated :user do
    get "landing/index"
  end

  get 'settings/index'
  get 'reports/index'
  get 'reset_usages/reset', as: :reset_usages
  match "internet_usages/scope_to_date" => "internet_usages#scope_to_date",  via: [:get]
  match "internet_usages/student_scope_to_date" => "internet_usages#student_scope_to_date",  via: [:get]
  match "students/scope_to_date" => "students#scope_to_date",  via: [:get]
  match "logins/sign_out_all" => "logins#sign_out_all",  via: [:get]

  resources :students do
    get :autocomplete_student_full_name, on: :collection
  	match "/profile" => "students#profile", as: :profile, via: [:get], on: :member
  	match "/usages" => "students#usages", as: :usages, via: [:get], on: :member
  end

  resources :logins
  resources :student_logins
  resources :alloted_times
  resources :users
  resources :courses
end
