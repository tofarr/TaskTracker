Rails.application.routes.draw do
  resources :notifications
  post "/task_search/submit", to: "task_searches#submit"
  resources :task_searches
  resources :access_tokens
  resources :activity_logs
  resources :task_links
  resources :comments
  resources :attachments
  resources :tasks
  resources :user_tags
  resources :task_tags
  resources :task_statuses
  get 'welcome/index'
  root :controller => 'welcome', :action => 'index'
  resources :sessions, :only => ['index', 'new', 'create', 'destroy']
  post "/sessions/logout", to: "sessions#destroy"
  resources :users
  get 'charts/status_pie'
  get 'charts/burndown_line'

  get "settings", to: "settings#index"
  get "settings/edit", to: "settings#edit"
  post "settings/update", to: "settings#update"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
