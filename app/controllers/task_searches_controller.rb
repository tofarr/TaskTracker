class TaskSearchesController < ApplicationController
  before_action :set_task_search, only: [:edit, :update, :destroy]
  skip_before_action :require_login, only: [:index, :show, :new]

  # GET /task_searches
  # GET /task_searches.json
  def index
    task_searches = TaskSearch.viewable_searches(current_user)
    task_searches = task_searches.where("title like ?", "%#{params[:q]}%") if params[:q]
    @task_searches = page(task_searches.order(params[:order] || :title))
  end

  # GET /task_searches/1
  # GET /task_searches/1.json
  def show
    @task_search = TaskSearch.viewable_searches(current_user).find(params[:id])
  end

  # GET /task_searches/new
  def new
    @task_search = TaskSearch.new
    @task_search.user = current_user
  end

  # GET /task_searches/1/edit
  def edit
  end

  # POST /task_searches
  # POST /task_searches.json
  def create
    @task_search = TaskSearch.new(TaskSearchesController.task_search_params(params))
    @task_search.user = current_user

    respond_to do |format|
      if @task_search.save
        format.html { redirect_to @task_search, notice: 'Task search was successfully created.' }
        format.json { render :show, status: :created, location: @task_search }
      else
        format.html { render :new }
        format.json { render json: @task_search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_searches/1
  # PATCH/PUT /task_searches/1.json
  def update
    respond_to do |format|
      if @task_search.update(TaskSearchesController.task_search_params(params))
        format.html { redirect_to @task_search, notice: 'Task search was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_search }
      else
        format.html { render :edit }
        format.json { render json: @task_search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_searches/1
  # DELETE /task_searches/1.json
  def destroy
    @task_search.destroy
    respond_to do |format|
      format.html { redirect_to task_searches_url, notice: 'Task search was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def submit
    if params[:create]
      process(:create)
      return
    elsif params[:update]
      process(:update)
      return
    else
      #redirect_to({controller: "tasks", action: 'index'}.merge(TaskSearchesController.task_search_params(params).as_json))
      redirect_to({controller: "tasks", action: 'index', task_search: params.fetch(:task_search, {}).as_json})
      return
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def self.task_search_params(params)
    params.fetch(:task_search, {}).permit(:query, :title, :public, :sort_order, :descending, {
      :task_tag_ids => [],
      :created_user_tag_ids => [],
      :assigned_user_tag_ids => [],
      :created_user_ids => [],
      :assigned_user_ids => [],
      :task_status_ids => []
    })
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_search
      @task_search = current_user.task_searches.find(params[:id])
    end
end
