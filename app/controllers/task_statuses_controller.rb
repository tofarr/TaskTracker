class TaskStatusesController < ApplicationController
  before_action :set_task_status, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  # GET /task_statuses
  # GET /task_statuses.json
  def index
    task_statuses = TaskStatus.all
    task_statuses = task_statuses.where("title like ? or description like ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q]
    @task_statuses = task_statuses.order(params[:order] || :title).page(params[:page])
  end

  # GET /task_statuses/1
  # GET /task_statuses/1.json
  def show
  end

  # GET /task_statuses/new
  def new
    @task_status = TaskStatus.new
  end

  # GET /task_statuses/1/edit
  def edit
  end

  # POST /task_statuses
  # POST /task_statuses.json
  def create
    @task_status = TaskStatus.new(task_status_params)
    attach_img(:icon)
    respond_to do |format|
      if @task_status.save
        format.html { redirect_to @task_status, notice: 'Task status was successfully created.' }
        format.json { render :show, status: :created, location: @task_status }
      else
        format.html { render :new }
        format.json { render json: @task_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_statuses/1
  # PATCH/PUT /task_statuses/1.json
  def update
    @task_status.assign_attributes(task_status_params)
    attach_img(:icon)
    respond_to do |format|
      if @task_status.save
        format.html { redirect_to @task_status, notice: 'Task status was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_status }
      else
        format.html { render :edit }
        format.json { render json: @task_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_statuses/1
  # DELETE /task_statuses/1.json
  def destroy
    @task_status.destroy
    respond_to do |format|
      format.html { redirect_to task_statuses_url, notice: 'Task status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def model_type
    'TaskStatus'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_status
      @task_status = TaskStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_status_params
      params.require(:task_status).permit(:title, :description, :requires_action, :default_apply, :color, :next_status_ids => [])
    end
end
