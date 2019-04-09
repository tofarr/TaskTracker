class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:index, :show]
  before_action :authorize_edit, only: [:edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @task_search = params[:task_search_id] ? TaskSearch.viewable_searches(current_user).find(params[:task_search_id]) : TaskSearch.new
    @task_search.assign_attributes(TaskSearchesController.task_search_params(params))
    @task_search.user = current_user
    @tasks = page(@task_search.search(current_user))
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @task.tags = TaskTag.where(default_apply: true)
    @task.created_user = current_user
    @task.status = TaskStatus.order(default_apply: :desc).first
    if params[:parent_id]
      parent = Task.find(params[:parent_id])
      raise ActionController::RoutingError.new('Not Found') unless parent.viewable_by(current_user)
      @task.parent = parent
      @task.tags = parent.tags
      @task.viewable = parent.viewable
      @task.editable = parent.editable
      @task.public = parent.public
      @task.commentable = parent.commentable
    else
      #Todo take from settings
      @task.viewable = true
      @task.editable = true
      @task.commentable = true
    end
    @task.priority = Task.where(parent_id: params[:parent_id]).order(:priority).last.priority || 0.5
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.created_user = current_user

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

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def model_type
    'Task'
  end

  private

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
end
