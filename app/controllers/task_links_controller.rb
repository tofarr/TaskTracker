class TaskLinksController < ApplicationController
  before_action :set_task_link, only: [:show, :edit, :destroy]

  # GET /task_links
  # GET /task_links.json
  def index
    @task_links = TaskLink.all
    if params[:task_id]
      task = Task.viewable_tasks(current_user).find(params[:task_id])
      @task_links = @task_links.where(id: [] + task.from_link_ids + task.to_link_ids)
    else
      @task_links = @task_links.where(from_task_id: params[:from_task_id]) if params[:from_task_id]
      @task_links = @task_links.where(to_task_id: params[:to_task_id]) if params[:to_task_id]
    end
    #Filter out duplicate....
    @task_links = @task_links.where("from_task_id < to_task_id or link_type <> 'duplicate'")

    #Apply security constraints
    #@task_links = Kaminari.paginate_array(@task_links.select { |task_link|
      #true
    #})

    @task_links = page(@task_links)
  end

  # GET /task_links/1
  # GET /task_links/1.json
  def show
  end

  # GET /task_links/new
  def new
    @task_link = TaskLink.new
    @task_link.from_task = Task.editable_tasks(current_user).find(params[:from_task_id]) if params[:from_task_id]
    @task_link.to_task = Task.editable_tasks(current_user).find(params[:to_task_id]) if params[:to_task_id]
  end

  # GET /task_links/1/edit
  def edit
  end

  # POST /task_links
  # POST /task_links.json
  def create
    @task_link = TaskLink.new(task_link_params)
    #Make sure user has access
    Task.editable_tasks(current_user).find(@task_link.from_task_id)
    Task.editable_tasks(current_user).find(@task_link.to_task_id)

    respond_to do |format|
      if @task_link.save
        format.html { redirect_to @task_link, notice: 'Task link was successfully created.' }
        format.json { render :show, status: :created, location: @task_link }
      else
        format.html { render :new }
        format.json { render json: @task_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_links/1
  # DELETE /task_links/1.json
  def destroy
    @task_link.destroy
    respond_to do |format|
      format.html { redirect_to task_links_url, notice: 'Task link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def model_type
    'TaskLink'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_link
      @task_link = TaskLink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_link_params
      params.require(:task_link).permit(:link_type, :from_task_id, :to_task_id)
    end
end
