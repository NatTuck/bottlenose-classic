
Bottlenose::Application.routes.draw do
  resources :terms

  resources :reg_requests

  resources :questions

  get "main/index"
  get "main/auth"
  post "main/resend_auth"
  get "main/logout"
  get "main/about"

  get  'settings' => 'settings#index'
  post 'settings/save'

  resources :users
  post 'users/:id/impersonate' => 'users#impersonate'

  resources :courses do
    resources :registrations
    resources :chapters
    resources :reg_requests
    resources :grade_types
    resources :assignments
  end

  get 'courses/:id/export_grades' => 'courses#export_grades'
  get 'courses/:id/bulk_add'      => 'courses#bulk_add'
  post 'courses/:id/bulk_add'     => 'courses#bulk_add'
  get 'courses/:id/public'        => 'courses#public'

  resources :registrations, :except => [:new]

  get 'registrations/:id/submissions_for_assignment/:assignment_id' =>
    'registrations#submissions_for_assignment'

  post 'registrations/:id/toggle_show' => 'registrations#toggle_show'

  resources :reg_requests, :except => [:new]

  resources :chapters

  resources :assignments do
    resources :submissions, :except => [:destroy]
  end

  get 'assignments/:assignment_id/manual_grade' =>
    'submissions#manual_grade'
  
  get 'assignments/:id/tarball' =>
    'assignments#tarball'

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
