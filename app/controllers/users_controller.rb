class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new, :create, :destroy]

  # GET /users
  # GET /users.json
  def index
    users = User.where(suspended: current_user.admin? ? (params[:suspended] || [true, false]) : false)
    users = users.where("username like ? or email like ? or name like ?", "%#{params[:q]}%", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q]
    @users = page(users.order(params[:order] || :username))
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
    UserTag.check_mutex(@user.tags)

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
    @user.assign_attributes(user_params)

    UserTag.check_mutex(@user.tags)

    #Can't change admin / suspend status of self
    if current_user.id == user_to_update.id
      if user_to_update.admin? != @user.admin? || user_to_update.suspended? != @user.suspended?
        raise ApplicationController::NotAuthorized
      end
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
    if current_user.id == @user.id
      raise ApplicationController::NotAuthorized
    end

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def model_type
    'User'
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :username, :password, :password_confirmation, :verification_code, :admin, :suspended, :avatar, :tag_ids => [])
    end
end
