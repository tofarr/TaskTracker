class ActivityLogsController < ApplicationController
  before_action :require_admin

  # GET /activity_logs
  # GET /activity_logs.json
  def index
    @activity_logs = ActivityLog.all
    @activity_logs = @activity_logs.where(model: params[:model]) if params[:model]
    @activity_logs = @activity_logs.where("created_at >= ?", params[:start_time]) if params[:start_time]
    @activity_logs = @activity_logs.where("created_at <= ?", params[:end_time]) if params[:end_time]
    @activity_logs = page(@activity_logs.order(params[:order] || {created_at: :desc}))
  end

  # GET /activity_logs/1
  # GET /activity_logs/1.json
  def show
    @activity_log = ActivityLog.find(params[:id])
  end

end
