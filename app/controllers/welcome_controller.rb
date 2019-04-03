class WelcomeController < ApplicationController
  def index
    redirect_to :controller => "tasks" and return if logged_in?
    redirect_to :controller => "sessions", :action => "new"
  end
end
