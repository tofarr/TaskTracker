class NotificationsController < ApplicationController

  # GET /notifications
  # GET /notifications.json
  def index
    notification_list
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
    @notification = Notification.new(params.require(:notification).permit(:task_id, :user_id, :message))
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
    @notification.assign_attributes(params.require(:notification).permit(:include_in_email, :seen))
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

  # PATCH /notifications
  # PATCH /notifications.json
  def update_all
    #Build a json file based on criteria and settings...
    @notification_job = BatchJob::NotificationUpsertJob.new(user: current_user)

    prepare_job(@notification_job) do |notification_job|
      attach_params_as_file_to_upsert_job(notification_job)
    end

    @notifications = page(notification_list)

    if @notification_job.save
      BatchProcessorJob.perform_later(@notification_job.id, @current_user.id)
      respond_to do |format|
        format.html { redirect_to :notifications, notice: 'Batch Job Submitted.' }
        format.json { render :show, status: :ok, location: url_for(controller: "", action: "update_all") }
      end
    else
      respond_to do |format|
        format.html { render :notifications }
        format.json { render json: @notification_job.errors, status: :unprocessable_entity }
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

  # DELETE /notifications
  # DELETE /notifications.json
  def destroy_all
    @notification_job = BatchJob::NotificationDestroyJob.new(user: current_user)

    prepare_job(@notification_job) do |notification_job|
      all_notification_updates = notification_list.select(:id).map do |notification|
        notification.as_json.slice("id")
      end
      notification_job.data.attach(io: StringIO.new(all_notification_updates.to_json), content_type: "application/json", filename: "upload.json")
    end

    if @notification_job.save
      BatchProcessorJob.perform_later(@notification_job.id, @current_user.id)
      respond_to do |format|
        format.html { redirect_to :notifications, notice: 'Batch Job Submitted.' }
        format.json { render :show, status: :ok, location: url_for(controller: "", action: "update_all") }
      end
    else
      respond_to do |format|
        format.html { render :notifications }
        format.json { render json: @notification_job.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def notification_list
      return @notifications if @notifications
      @notifications = Notification.viewable_notifications(current_user)
      @notifications = @notifications.where("message like ?", "%#{params[:q]}%") if params[:q]
      @notifications = @notifications.order(created_at: :desc)
    end


    def attach_params_as_file_to_upsert_job(job)
      updates = AppUtils.collapse(params.require(:notification).permit(:include_in_email, :seen).to_h) || {}
      notifications = notification_list.select(:id)
      all_notification_updates = notifications.map do |notification|
        updates.clone.merge(id: notification.id)
      end
      job.data.attach(io: StringIO.new(all_notification_updates.to_json), content_type: "application/json", filename: "upload.json")
    end
end
