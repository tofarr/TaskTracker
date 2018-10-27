Rails.application.routes.draw do
  get 'welcome/index'
  root :controller => 'users', :action => 'index'
  resources :sessions
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
