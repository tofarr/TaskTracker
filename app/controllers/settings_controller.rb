class SettingsController < ApplicationController
  before_action :require_admin

  # GET /settings
  # GET /settings.json
  def index
    @setting = Setting
  end

  # GET /settings/edit
  def edit
    @setting = Setting
  end

  # PATCH/PUT /settings
  # PATCH/PUT /settings.json
  def update
    params.require(:setting).permit(Setting.get_all.keys).each do |k, v|
      Setting[k] = v
    end
    respond_to do |format|
      format.html { redirect_to :action => "index", notice: 'Comment were successfully updated.' }
      format.json { render :index, status: :ok }
    end
  end

end
