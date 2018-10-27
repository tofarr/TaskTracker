class SessionsController < ActionController::Base

  def index
    redirect_to action: "new"
  end

  def new
  end

  def create
    user = User.find_by("username=? or email=?", params[:user], params[:user])
    if user && user.authenticate(params[:password])
      if user.suspended?
        flash[:notice] = I18n.t "user_suspended"
        redirect_to action: "new"
      else
        session[:user_id] = user.id
        redirect_to controller: "welcome", action: "index"
      end
    else
      flash[:notice] = I18n.t "login_incorrect"
      redirect_to action: "new"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = I18n.t "logged_out"
    redirect_to action: "new"
  end
end
