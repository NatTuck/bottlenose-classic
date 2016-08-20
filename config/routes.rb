
Bottlenose::Application.routes.draw do
  resources :grading_jobs
  get "main/index"
  get "main/auth"
  post "main/resend_auth"
  get "main/logout"
  get "main/about"

  get  'settings' => 'settings#index'
  post 'settings/save'

  resources :users
  post 'users/:id/impersonate' => 'users#impersonate'

  resources :terms

  resources :courses do
    resources :registrations
    resources :reg_requests
    resources :buckets
    resources :assignments
    resources :teams, except: [:index, :new]
    resources :team_sets, except: [:edit]
  end

  post 'courses/:id/export_grades'  => 'courses#export_grades'
  post 'courses/:id/export_summary' => 'courses#export_summary'
  get  'courses/:id/bulk_add'       => 'courses#bulk_add'
  post 'courses/:id/bulk_add'       => 'courses#bulk_add'
  get  'courses/:id/public'         => 'courses#public'
  get  'courses/:course_id/team_status' => 'teams#status'
  post 'courses/:course_id/team_sets/:id/clone' => 'team_sets#clone'

  resources :registrations, except: [:new]

  get 'registrations/:id/submissions_for_assignment/:assignment_id' =>
    'registrations#submissions_for_assignment'

  post 'registrations/:id/toggle_show' => 'registrations#toggle_show'

  resources :reg_requests, except: [:new]

  resources :assignments do
    resources :submissions, except: [:destroy]
  end

  get 'assignments/:id/tarball' =>
    'assignments#tarball'

  resources :submissions, except: [:destroy]

  root :to => 'main#index'
end

