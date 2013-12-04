Tms::Application.routes.draw do
  root "static_pages#home"
  resources :trainees do
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
  match "/trainees/:trainee_id/enrollments/:enrollment_id/:activate", 
    to: "enrollments#update", as: "trainee_enrollment_activate", via: :patch

  namespace :admin do
    root "static_pages#dashboard"
    resources :sessions, only: [:new, :create, :destroy]
    resources :supervisors do
      resources :courses do
        resource :trainee_list, only: [:show, :update]
        resources :course_subjects, only: :update
      end
    end
    resources :trainees, only: [:index, :show]
    resources :subjects
    match "/signin",  to: "sessions#new",        via: :get
    match "/signout", to: "sessions#destroy",    via: :delete
  end
end