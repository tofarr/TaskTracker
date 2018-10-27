class WelcomeController < ApplicationController
  def index
    redirect_to :controller => "users"
  end
end
