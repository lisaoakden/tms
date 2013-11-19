Tms::Application.routes.draw do
  root "static_pages#home"
  resources :users do
    resources :enrollments do
      resources :enrollment_subjects do
        resource :task_list, only: [:show, :update]
      end
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :enrollment_subjects
  resources :activities
  match "/signin",  to: "sessions#new",         via: :get
  match "/signout", to: "sessions#destroy",     via: :delete
  match "/users/:user_id/enrollments/:enrollment_id/:activate", 
    to: "enrollments#update", as: "activate", via: "patch"

  namespace :admin do
    root "static_pages#dashboard"
    resources :sessions, only: [:new, :create, :destroy]
    resources :supervisors do
      resources :courses
    end
    resources :users

    match "/signin",  to: "sessions#new",        via: :get
    match "/signout", to: "sessions#destroy",    via: :delete
  end
end