Rails.application.routes.draw do
  resources :projects_users
  mount_devise_token_auth_for 'User', at: 'auth'

  resources :projects
  resources :folders
  resources :tasks
  resources :timesheets
end
