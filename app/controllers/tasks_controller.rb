require "app_utils"

class TasksController < ApplicationController

  before_action :set_task, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:index, :show]
  before_action :authorize_edit, only: [:edit, :update, :destroy]
  before_action :set_task_search, only: [:search, :index, :edit_all, :update_all, :destroy_all]

  # GET /tasks/search
  def search
  end

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = task_list(true)
    @tasks = page(@tasks)
    respond_to do |format|
      format.html
      format.json
      format.rss
      format.csv { send_data @tasks.to_csv, filename: "tasks-#{Date.today}.csv" }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @task.tags = TaskTag.where(default_apply: true)
    @task.created_by_user = current_user
    @task.status = TaskStatus.order(default_apply: :desc).first
    if params[:parent_id]
      parent = Task.find(params[:parent_id])
      raise ActionController::RoutingError.new('Not Found') unless parent.viewable_by?(current_user)
      @task.parent_id = parent.id
      @task.tags = parent.tags
      @task.viewable = parent.viewable
      @task.editable = parent.editable
      @task.public_viewable = parent.public_viewable
      @task.commentable = parent.commentable
    else
      #Todo take from settings
      @task.viewable = true
      @task.editable = true
      @task.commentable = true
    end
    @task.priority = Task.where(parent_id: params[:parent_id]).order(:priority).last&.priority || 0.5
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.created_by_user = current_user

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /tasks/edit_all
  # GET /tasks/edit_all.json
  def edit_all
  end

  # PATCH /tasks
  # PATCH /tasks.json
  def update_all
    @task_job = BatchJob::TaskUpsertJob.new(user: current_user)

    prepare_job(@task_job) do |task_job|
      attach_params_as_file_to_upsert_job(task_job)
    end

    if @task_job.save
      BatchProcessorJob.perform_later(@task_job.id, @current_user.id)
      respond_to do |format|
        format.html { redirect_to tasks_edit_all_url, notice: 'Batch Job Submitted.' }
        format.json { render :show, status: :ok, location: url_for(controller: "", action: "update_all") }
      end
    else
      respond_to do |format|
        format.html { render :edit_all }
        format.json { render json: @task_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # DELETE /tasks
  # DELETE /tasks.json
  def destroy_all
    @task_job = BatchJob::TaskDestroyJob.new(user: current_user)

    prepare_job(@task_job) do |task_job|
      all_task_updates = task_list.select(:id).map do |task|
        task.as_json.slice("id")
      end
      task_job.data.attach(io: StringIO.new(all_task_updates.to_json), content_type: "application/json", filename: "upload.json")
    end

    if @task_job.save
      BatchProcessorJob.perform_later(@task_job.id, @current_user.id)
      respond_to do |format|
        format.html { redirect_to tasks_edit_all_url, notice: 'Batch Job Submitted.' }
        format.json { render :show, status: :ok, location: url_for(controller: "", action: "update_all") }
      end
    else
      respond_to do |format|
        format.html { render :edit_all }
        format.json { render json: @task_job.errors, status: :unprocessable_entity }
      end
    end
  end

  def model_type
    'Task'
  end

  private

    def set_task_search
      task_search
    end

    def task_search
      @task_search ||= TaskSearch.get_search(current_user, params)
    end

    def task_list(force_order = false)
      task_search.search(current_user, force_order)
    end

    def authorize_edit
      unless @task.editable_by?(current_user)
        raise ApplicationController::NotAuthorized
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.viewable_tasks(current_user).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:title, :description, :parent_id, :assigned_user_id, :status_id, :priority, :due_date, :estimate, :viewable, :editable, :commentable, :public_viewable, {:tag_ids => []})
    end

    def attach_params_as_file_to_upsert_job(job)

      updates = AppUtils.collapse(task_params.to_h) || {}
      add_tag_ids = params[:task][:add_tag_ids] if params[:task]
      remove_tag_ids = params[:task][:remove_tag_ids] if params[:task]
      tasks = task_list.select(:id)
      all_task_updates = tasks.map do |task|
        ret = updates.clone.merge(id: task.id)
        ret[:tag_ids] = process_list(task.tag_ids, add_tag_ids, remove_tag_ids)
        ret
      end
      job.data.attach(io: StringIO.new(all_task_updates.to_json), content_type: "application/json", filename: "upload.json")

    end
end
