class WelcomeController < ApplicationController
  def index
    redirect_to :controller => "tasks"
  end
end
