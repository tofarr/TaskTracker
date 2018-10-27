class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(params[:order] || :username).page(params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new

    unless current_user.admin?
      raise ApplicationController::NotAuthorized
    end

    @user = User.new
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
    unless current_user.admin?
      raise ApplicationController::NotAuthorized
    end
    @user = User.new(user_params)

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

    #Can't change admin / suspend status of self
    if current_user.id == @user.id
      updated_user = @user.clone.assign_attributes(user_params)
      if updated_user.admin? != @user.admin? || updated_user.suspended? != @user.suspended?
        raise ApplicationController::NotAuthorized
      end
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy

    # Only admins can delete, and even they can't delete themselves.
    if (!current_user.admin?) || current_user.id == @user.id
      raise ApplicationController::NotAuthorized
    end

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :username, :password, :password_confirmation, :verification_code, :admin, :suspended)
    end
end
