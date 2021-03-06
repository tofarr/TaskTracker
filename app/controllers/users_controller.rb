require "app_utils"

class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, except: [:index, :show, :edit, :update]
  before_action :set_user_search, only: [:search, :index, :edit_all, :update_all, :destroy_all]


  # GET /users/search
  def search
  end

  # GET /users
  # GET /users.json
  # GET /users.csv
  def index
    @users = user_list(true)
    @users = page(@users)
    respond_to do |format|
      format.html
      format.json
      format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.tags = UserTag.where(default_apply: true)
  end

  # GET /users/1/edit
  def edit
    unless current_user.admin? || current_user.id == @user.id
      raise ApplicationController::NotAuthorized
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    attach_file(:avatar)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    # Unless admin, can only edit self
    unless current_user.admin? || current_user.id == @user.id
      raise ApplicationController::NotAuthorized
    end

    user_to_update = @user.clone
    if user_to_update.password_digest.present? && user_params[:password].present?
      raise ApplicationController::NotAuthorized unless user_to_update.authenticate(params[:user][:existing_password])
    end
    @user.assign_attributes(user_params)
    attach_file(:avatar)

    #Can't change admin / suspend status of self
    if current_user.id == user_to_update.id
      if user_to_update.admin? != @user.admin? || user_to_update.suspended? != @user.suspended?
        raise ApplicationController::NotAuthorized
      end
    # Can't set somebody elses password.
    elsif user_params[:password]
      raise ApplicationController::NotAuthorized
    end

    #Admin only assignment tags can only be assigned / unassigned by admins
    unless current_user.admin?
      (user_to_update.tags - @user.tags).each do |tag|
        raise ApplicationController::NotAuthorized if tag.only_admin_can_apply?
      end
      (@user.tags - user_to_update.tags).each do |tag|
        raise ApplicationController::NotAuthorized if tag.only_admin_can_apply?
      end
    end

    respond_to do |format|
      if @user.save

        if user_params[:password]
          session[:user_id] = @user.id
          @access_token = nil
        end

        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/edit_all
  # GET /users/edit_all.json
  def edit_all
  end

  # PATCH /users
  # PATCH /users.json
  def update_all
    #Build a json file based on criteria and settings...
    @user_job = BatchJob::UserUpsertJob.new(user: current_user)

    prepare_job(@user_job) do |user_job|
      attach_params_as_file_to_upsert_job(user_job)
    end

    if @user_job.save
      BatchProcessorJob.perform_later(@user_job.id, @current_user.id)
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'Batch Job Submitted.' }
        format.json { render :show, status: :ok, location: url_for(controller: "", action: "update_all") }
      end
    else
      respond_to do |format|
        format.html { render :edit_all }
        format.json { render json: @user_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy

    # Only admins can delete, and even they can't delete themselves.
    if current_user.id == @user.id
      raise ApplicationController::NotAuthorized
    end

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # DELETE /users
  # DELETE /users.json
  def destroy_all
    @user_job = BatchJob::UserDestroyJob.new(user: current_user)

    prepare_job(@user_job) do |user_job|
      all_user_updates = user_list.select(:id).map do |user|
        user.as_json.slice("id")
      end
      user_job.data.attach(io: StringIO.new(all_user_updates.to_json), content_type: "application/json", filename: "upload.json")
    end

    if @user_job.save
      BatchProcessorJob.perform_later(@user_job.id, @current_user.id)
      respond_to do |format|
        format.html { redirect_to users_edit_all_url, notice: 'Batch Job Submitted.' }
        format.json { render :show, status: :ok, location: url_for(controller: "", action: "update_all") }
      end
    else
      respond_to do |format|
        format.html { render :edit_all }
        format.json { render json: @user_job.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_welcome_email
    @user = User.find(params[:user_id])
    raise ApplicationController::NotAuthorized if @user.password_digest
    UserMailer.welcome(@user).deliver_later
    respond_to do |format|
      format.html { redirect_to user_path(@user), notice: 'Invitation Email should Arrive Soon!' }
      format.json { head :no_content }
    end
  end

  def model_type
    'User'
  end

  private

    def set_user_search
      user_search
    end

    def user_search
      @user_search ||= Search::UserSearch.new(params[:user_search]&.permit!&.to_h&.symbolize_keys)
    end

    def user_list(force_order = false)
      user_search.search(current_user, force_order)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      @user_params ||= params.require(:user).permit(:email, :name, :username, :password, :password_confirmation, :admin, :suspended, :locale, :tag_ids => [])
    end

    def attach_params_as_file_to_upsert_job(job)
      updates = AppUtils.collapse(user_params.to_h) || {}
      add_tag_ids = params[:user][:add_tag_ids] if params[:user]
      remove_tag_ids = params[:user][:remove_tag_ids] if params[:user]
      users = user_list.select(:id, :username)
      all_user_updates = users.map do |user|
        ret = updates.clone.merge(username: user.username)
        ret[:tag_ids] = process_list(user.tag_ids, add_tag_ids, remove_tag_ids)
        ret
      end
      job.data.attach(io: StringIO.new(all_user_updates.to_json), content_type: "application/json", filename: "upload.json")
    end
end
