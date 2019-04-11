class NotificationsController < ApplicationController

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.viewable_notifications(current_user)
    @notifications = @notifications.where("message like ?", "%#{params[:q]}%") if params[:q]
    @notifications = @notifications.order(created_at: :desc)
    @notifications = page(@notifications)
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
    @notification = Notification.viewable_notifications(current_user).find(params[:id])
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
    @notification.created_by_user = current_user
  end

  # GET /notifications/1/edit
  def edit
    @notification = Notification.editable_notifications(current_user).find(params[:id])
  end

  # POST /notifications
  # POST /notifications.json
  def create
    @notification = Notification.new(notification_params)
    @notification.created_by_user = current_user

    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: 'Notification was successfully created.' }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update
    @notification = Notification.editable_notifications(current_user).find(params[:id])
    unless @notification.editable_by?(current_user)
      raise ApplicationController::NotAuthorized
    end
    @notification.assign_attributes(notification_params)
    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: 'Notification was successfully updated.' }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification = Notification.editable_notifications(current_user).find(params[:id])
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:task_id, :user_id, :message)
    end
end
