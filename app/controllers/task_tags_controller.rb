class TaskTagsController < ApplicationController
  before_action :set_task_tag, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  # GET /task_tags
  # GET /task_tags.json
  def index
    task_tags = TaskTag.all
    task_tags = task_tags.where("title like ? or description like ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q]
    @task_tags = page(task_tags.order(params[:order] || :title))
  end

  # GET /task_tags/1
  # GET /task_tags/1.json
  def show
  end

  # GET /task_tags/new
  def new
    @task_tag = TaskTag.new
  end

  # GET /task_tags/1/edit
  def edit
  end

  # POST /task_tags
  # POST /task_tags.json
  def create
    @task_tag = TaskTag.new(task_tag_params)
    attach_file(:icon)
    respond_to do |format|
      if @task_tag.save
        format.html { redirect_to @task_tag, notice: 'Task tag was successfully created.' }
        format.json { render :show, status: :created, location: @task_tag }
      else
        format.html { render :new }
        format.json { render json: @task_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_tags/1
  # PATCH/PUT /task_tags/1.json
  def update
    @task_tag.assign_attributes(task_tag_params)
    attach_file(:icon)
    respond_to do |format|
      if @task_tag.save
        format.html { redirect_to @task_tag, notice: 'Task tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_tag }
      else
        format.html { render :edit }
        format.json { render json: @task_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_tags/1
  # DELETE /task_tags/1.json
  def destroy
    @task_tag.destroy
    respond_to do |format|
      format.html { redirect_to task_tags_url, notice: 'Task tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def model_type
    'TaskTag'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_tag
      @task_tag = TaskTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_tag_params
      params.require(:task_tag).permit(:title, :description, :requires_action, :only_admin_can_apply, :default_apply, :color, :mutex_ids => [])
    end
end
