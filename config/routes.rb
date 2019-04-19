Rails.application.routes.draw do
  resources :sprints

  patch "notifications", to: "notifications#update_all"
  delete "notifications", to: "notifications#destroy_all"
  resources :notifications

  post "/task_search/submit", to: "task_searches#submit"
  resources :task_searches

  patch "access_tokens", to: "access_tokens#update_all"
  delete "access_tokens", to: "access_tokens#destroy_all"
  resources :access_tokens

  resources :activity_logs
  resources :task_links
  resources :comments
  resources :attachments

  get "tasks/edit_all", to: "tasks#edit_all"
  patch "tasks", to: "tasks#update_all"
  delete "tasks", to: "tasks#destroy_all"
  resources :tasks

  resources :user_tags
  resources :task_tags
  resources :task_statuses
  get 'welcome/index'
  root :controller => 'welcome', :action => 'index'
  resources :sessions, :only => ['index', 'new', 'create', 'destroy']
  post "/sessions/logout", to: "sessions#destroy"

  get "users/search", to: "users#search"
  get "users/edit_all", to: "users#edit_all"
  patch "users", to: "users#update_all"
  delete "users", to: "users#destroy_all"
  resources :users do
    post "send_welcome_email"
  end

  get 'charts/status_pie'
  get 'charts/burndown_line'

  get "settings", to: "settings#index"
  get "settings/edit", to: "settings#edit"
  post "settings/update", to: "settings#update"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
