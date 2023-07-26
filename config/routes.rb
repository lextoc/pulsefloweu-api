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

  resources :timesheets
end
