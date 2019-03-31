class AttachmentsController < ApplicationController
  before_action :set_attachment, only: [:edit, :update, :destroy]

  # GET /attachments
  # GET /attachments.json
  def index
    attachments = Attachment.viewable_attachments(current_user)
    attachments = attachments.where("title like ? or description like ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q]
    attachments = attachments.where(task_id: params[:task_id]) if params[:task_id]
    attachments = attachments.where(user_id: params[:user_id]) if params[:user_id]
    @attachments = attachments.order(params[:order] || :title).page(params[:page])
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    Attachment.viewable_attachments(current_user).find(params[:id])
  end

  # GET /attachments/new
  def new
    @attachment = Attachment.new
    set_task if params[:task_id]
    @attachment.user = @current_user
  end

  # GET /attachments/1/edit
  def edit
    if @attachment.user != @current_user
      raise ApplicationController::NotAuthorized
    end
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @attachment = Attachment.new(attachment_params)
    set_task
    @attachment.user = @current_user
    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachment, notice: 'Attachment was successfully created.' }
        format.json { render :show, status: :created, location: @attachment }
      else
        format.html { render :new }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attachments/1
  # PATCH/PUT /attachments/1.json
  def update
    if @attachment.user != @current_user
      raise ApplicationController::NotAuthorized
    end
    respond_to do |format|
      if @attachment.update(attachment_params)
        format.html { redirect_to @attachment, notice: 'Attachment was successfully updated.' }
        format.json { render :show, status: :ok, location: @attachment }
      else
        format.html { render :edit }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    @attachment.destroy
    respond_to do |format|
      format.html { redirect_to attachments_url, notice: 'Attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Attachment.editable_attachments(current_user).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:title, :description, :data)
    end
end
