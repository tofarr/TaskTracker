module LoginHelper

  def current_user
    @current_user
  end

  def logged_in?
    current_user.present? && !current_user.suspended?
  end

  NotAuthorized = Class.new(StandardError)

  def require_admin
    unless current_user && current_user.admin?
      raise AuthenticationHelper::NotAuthorized
    end
  end

  def do_login
    if request.headers['Authorization'].present?
      # Client initiated with Http basic authentication - No session is created here!!!
      authenticate_or_request_with_http_basic('Administration') do |username, password|
        user = User.find_by("username=? or email=?", username, username)
        if user && user.authenticate(password)
          @current_user = user
          true
        else
          false
        end
      end
    else
      token = params[:token] || request.headers[:token]
      if token
        access_token = AccessToken.active_access_tokens.find_by_token(token)
        raise LoginHelper::NotAuthorized unless access_token
        @token = token
        @current_user = access_token.user
        if @current_user.password_digest.blank?
          flash[:error] = I18n.t "password_update_required"
          if controller_name == 'users'
            true
          else
            redirect_to controller: "users",  action: "edit", id: @current_user.id
          end
        else
          true
        end
      else
        @current_user = User.find_by_id(session[:user_id])
      end
    end
  end

  def require_login
    unless logged_in?
      flash[:error] = I18n.t "login_required"
      redirect_to controller: "sessions", action: "new"
    end
  end

  #Set the timezone to be used to parse dates from that in the current user
  def set_time_zone
    begin
      Time.zone = current_user.try(:timezone) || "UTC"
    rescue
      logger.warn "Invalid timezone #{current_user.try(:timezone)} for user #{current_user.id}"
      Time.zone = "UTC"
    end
  end
end
