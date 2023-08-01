Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    token_validations: 'overrides/token_validations'
  }

  resources :projects
  get 'projects/:id/folders', to: 'projects#folders'

  resources :folders
  get 'folders/:id/tasks', to: 'folders#tasks'

  resources :tasks
  get 'tasks/:id/time_entries', to: 'tasks#time_entries'

  resources :time_entries

  namespace :misc do
    post 'stop/all', to: 'time_entries#stop'

    get 'running_timers', to: 'time_entries#running_timers'

    get 'timesheets_per_day', to: 'timesheets#timesheets_per_day'
    get 'timesheets_per_week', to: 'timesheets#timesheets_per_week'
  end
end
