
Bottlenose::Application.routes.draw do
  resources :questions

  get "main/index"
  get "main/auth"
  post "main/resend_auth"
  get "main/logout"

  resources :users
  match 'users/:id/impersonate' => 'users#impersonate'

  resources :courses do
    resources :registrations
    resources :chapters
  end

  resources :registratons

  resources :chapters do
    resources :lessons
    resources :assignments
  end

  resources :assignments do
    resources :submissions, :only => [:create]
  end

  resources :submissions, :only => [:destroy]

  resources :lessons do
    resources :questions, :only => [:create]
  end

  resources :questions, :only => [:update, :destroy] do
    resources :answers, :only => [:create]
  end

  resources :answers, :only => [:destroy]
  
  root :to => 'main#index'
end
