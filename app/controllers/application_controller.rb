require 'data_uri'

class ApplicationController < ActionController::Base

  include ApplicationHelper
  before_action :require_login
  helper_method :text_color
  after_action :log_create, only: :create
  after_action :log_update, only: :update
  after_action :log_destroy, only: :destroy

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

  def log_create
    if model_obj && model_obj&.persisted?
      ActivityLog.create(model_type: model_type,
        model_id: model_obj&.id,
        user_id: current_user.id,
        username: current_user.username,
        action: 'CREATE',
        new_value: model_obj)
    end
  end

  def log_update
    if model_type && model_obj&.errors&.empty?
      ActivityLog.create(model_type: model_type,
        model_id: model_obj&.id,
        user_id: current_user.id,
        username: current_user.username,
        action: 'UPDATE',
        new_value: model_obj)
    end
  end

  def log_destroy
    if model_type && model_obj&.destroyed?
      ActivityLog.create(model_type: model_type,
        user_id: current_user.id,
        model_id: model_obj&.id,
        username: current_user.username,
        action: 'DESTROY')
    end
  end

  def model_type
    return nil
  end

  def model_obj
    self.instance_variable_get("@#{model_type.underscore}")
  end

  def attach_img(attr_sym)
    img = params[model_type.underscore.to_sym][attr_sym]
    if img
      if img.class.name == 'String' && img.starts_with?('data:') # String was sent - manually convert to file
        uri = URI::Data.new(img)
        model_obj.send(attr_sym).attach(io: StringIO.new(uri.data), filename: "image.#{uri.content_type[6,uri.content_type.length]}")
      else
        model_obj.send(attr_sym).attach(img)
      end
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
