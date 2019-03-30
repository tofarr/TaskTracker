class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:index, :show]
  before_action :authorize_edit, only: [:edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    tasks = current_user_tasks
    tasks = tasks.where("title like ? or description like ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q]
    @tasks = page(tasks.order(params[:order] || {priority: :desc}))
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
    @task.priority = 0.5
    @task.viewable = @task.editable = @task.commentable = true
    @task.status = TaskStatus.order(default_apply: :desc).first
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

  private
    def current_user_tasks
      tasks = Task.all
      if logged_in?
        unless current_user.admin?
          tasks = tasks.where("created_user_id=? or assigned_user_id=? or viewable=true or (SELECT count(*) FROM edit_user_tags WHERE edit_user_tags.task_id = tasks.id AND edit_user_tags.user_id = ?) > 0",
            current_user.id, current_user.id, current_user.id)
        end
      else
        tasks = tasks.where(public_viewable: true) unless logged_in?
      end
      tasks
    end

    def authorize_edit
      unless @task.editable_by?(current_user)
        raise ApplicationController::NotAuthorized
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = current_user_tasks.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:title, :description, :parent_id, :assigned_user_id, :status_id, :priority, :due_date, :estimate, :viewable, :editable, :commentable, :public_viewable)
    end
end
