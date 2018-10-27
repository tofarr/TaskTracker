Rails.application.routes.draw do
  get 'welcome/index'
  root :controller => 'users', :action => 'index'
  resources :sessions, :only => ['index', 'new', 'create', 'destroy']
  post "/sessions/logout", to: "sessions#destroy"
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
