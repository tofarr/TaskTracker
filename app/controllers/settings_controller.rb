class SettingsController < ApplicationController
  before_action :require_admin, only: [:edit, :update]
  skip_before_action :require_login

  # GET /settings
  # GET /settings.json
  def index
    @setting = Setting
    @settings = Setting.get_all
    @settings = @settings.except(:private_key) unless current_user&.admin?
  end

  # GET /settings/edit
  def edit
    @setting = Setting
  end

  # PATCH/PUT /settings
  # PATCH/PUT /settings.json
  def update
    params.require(:setting).permit(Setting.get_all.keys).each do |k, v|
      # Does not do nulls Handles basic type casting
      old_value = Setting[k]
      if old_value.is_a?(Integer)
        Setting[k] = v.to_i
      elsif old_value.is_a?(Float)
        Setting[k] = v.to_f
      elsif old_value.is_a?(TrueClass) || old_value.is_a?(FalseClass)
        Setting[k] = ActiveModel::Type::Boolean.new.cast(v)
      else
        Setting[k] = v
      end
    end
    respond_to do |format|
      format.html { redirect_to :action => "index", notice: 'Comment were successfully updated.' }
      format.json { render :index, status: :ok }
    end
  end

end
