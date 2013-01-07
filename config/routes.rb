
Bottlenose::Application.routes.draw do
  resources :terms

  resources :reg_requests

  resources :questions

  get "main/index"
  get "main/auth"
  post "main/resend_auth"
  get "main/logout"

  resources :users
  match 'users/:id/impersonate' => 'users#impersonate'

  resources :courses do
    resources :registrations, :except => [:new]
    resources :chapters
    resources :reg_requests
  end

  match 'courses/:id/export_grades' => 'courses#export_grades'

  resources :registrations, :except => [:new]

  match 'registrations/:id/submissions_for_assignment/:assignment_id' =>
    'registrations#submissions_for_assignment'

  resources :reg_requests, :except => [:new]

  resources :chapters do
    resources :lessons
    resources :assignments
  end

  resources :assignments do
    resources :submissions, :except => [:destroy]
  end

  match 'assignments/:assignment_id/manual_grade' =>
    'submissions#manual_grade'

  resources :submissions

  resources :lessons do
    resources :questions
  end

  resources :questions, :only => [:edit, :update, :destroy] do
    resources :answers, :only => [:create, :update]
  end

  resources :answers, :only => [:destroy]
  
  root :to => 'main#index'
end
