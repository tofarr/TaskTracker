Rails.application.routes.draw do
  resources :comments
  resources :attachments
  resources :tasks
  resources :user_tags
  resources :task_tags
  resources :task_statuses
  get 'welcome/index'
  root :controller => 'tasks', :action => 'index'
  resources :sessions, :only => ['index', 'new', 'create', 'destroy']
  post "/sessions/logout", to: "sessions#destroy"
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
