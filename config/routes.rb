Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  resources :projects
  # resources :projects_users
  resources :folders
  # resources :folders_users
  resources :tasks
  resources :timesheets
end
