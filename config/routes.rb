Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  resources :projects
  # resources :projects_users
  get 'projects/:id/folders', to: 'projects#folders'

  resources :folders
  # resources :folders_users
  get 'folders/:id/tasks', to: 'folders#tasks'

  resources :tasks
  # resources :tasks_users
  get 'tasks/:id/time_entries', to: 'tasks#time_entries'

  resources :time_entries

  post 'misc/stop/all', to: 'time_entries#stop'

  namespace :misc do
    # get 'tasks/:id/total_duration_of_time_entries', to: 'tasks#total_duration_of_time_entries'
  end
end
