Tms::Application.routes.draw do
  get "enrollment_subjects/show"
  get "courses/show"
  get "subjects/show"
  resources :users do
    resources :enrollments do
      resources :enrollment_subjects
      resources :task_lists
    end
  end
  resources :courses
  resources :enrollment_tasks
  resources :sessions, only: [:new, :create, :destroy]
  resources :enrollment_subjects
  resources :activities

  root "static_pages#home"
  match "/signin",  to: "sessions#new",         via: "get"
  match "/signout", to: "sessions#destroy",     via: "delete"
  match "/users/:user_id/enrollments/:enrollment_id/:activate", to: "enrollments#update", as: "activate", via: "patch"
end
