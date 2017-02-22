Rails.application.routes.draw do
  
  get 'users/admin/index', as: :admin_index

  root 'users/admin#index'

	devise_for :users, :controller => {:sessions  => 'sessions'}, :skip => :registrations do
    delete '/logout', :to => 'sessions#destroy', :as => :destroy_user_session
    get '/login', :to => 'sessions#new', :as => :new_user_session
    post '/login', :to => 'sessions#create', :as => :user_session
	end

  resources :students
  resources :logins
  resources :student_logins
end
