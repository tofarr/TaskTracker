class ApplicationController < ActionController::Base

  before_action :require_login

  def current_user
    unless @current_user
      @current_user = User.find_by_id(session[:user_id])
    end
    @current_user
  end

  def logged_in?
    current_user.present? && !current_user.suspended?
  end


  NotAuthorized = Class.new(StandardError)

  def require_admin
    unless current_user && current_user.admin?
      raise ApplicationController::NotAuthorized
    end
  end

  private

  def require_login
    unless logged_in?
      flash[:error] = I18n.t "login_required"
      redirect_to controller: "sessions", action: "new"
    end
  end

  def page(query)
    query.page(params[:page]).per(params[:per] || 10)
  end
end
