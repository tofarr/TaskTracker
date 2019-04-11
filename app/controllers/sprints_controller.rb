class SprintsController < ApplicationController
  before_action :require_admin, only: [:edit, :update, :destroy]
  before_action :set_sprint, only: [:edit, :update, :destroy]

  # GET /sprints
  # GET /sprints.json
  def index
    @sprints = Sprint.viewable_sprints(current_user)
    @sprints = @sprints.where("title like ? or description like ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q]
    @sprints = @sprints.includes(:users).where(users: {id: params[:user_id]}) if params[:user_id]
    @sprints = @sprints.includes(:tasks).where(tasks: {id: params[:task_id]}) if params[:task_id]
    @sprints = page(@sprints.order(params[:order] || :title))
  end

  # GET /sprints/1
  # GET /sprints/1.json
  def show
    @sprint = Sprint.viewable_sprints(current_user).find(params[:id])
  end

  # GET /sprints/new
  def new
    @sprint = Sprint.new
  end

  # GET /sprints/1/edit
  def edit
  end

  # POST /sprints
  # POST /sprints.json
  def create
    @sprint = Sprint.new(sprint_params)

    respond_to do |format|
      if @sprint.save
        format.html { redirect_to @sprint, notice: 'Sprint was successfully created.' }
        format.json { render :show, status: :created, location: @sprint }
      else
        format.html { render :new }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sprints/1
  # PATCH/PUT /sprints/1.json
  def update
    respond_to do |format|
      puts "TRACE:update:1:#{@sprint}"
      @sprint.assign_attributes(sprint_params)
      puts "TRACE:update:2:#{@sprint}"
      if @sprint.update(sprint_params)
        format.html { redirect_to @sprint, notice: 'Sprint was successfully updated.' }
        format.json { render :show, status: :ok, location: @sprint }
      else
        format.html { render :edit }
        format.json { render json: @sprint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sprints/1
  # DELETE /sprints/1.json
  def destroy
    @sprint.destroy
    respond_to do |format|
      format.html { redirect_to sprints_url, notice: 'Sprint was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sprint
      @sprint = Sprint.editable_sprints(current_user).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sprint_params
      params.require(:sprint).permit(:title, :start_at, :finish_at, {:user_ids => []}, {:task_ids => []})
    end
end
