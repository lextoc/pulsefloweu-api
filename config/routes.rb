Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    token_validations: 'overrides/token_validations'
  }

  resources :projects
  resources :folders
  resources :tasks
  resources :time_entries

  namespace :misc do
    post 'stop/all', to: 'time_entries#stop'

    get 'running_time_entries', to: 'time_entries#running_time_entries'

    get 'timesheets_per_day', to: 'timesheets#timesheets_per_day'
    get 'timesheets_per_week', to: 'timesheets#timesheets_per_week'
  end
end
