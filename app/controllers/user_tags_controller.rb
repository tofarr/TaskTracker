class UserTagsController < ApplicationController
  before_action :set_user_tag, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  # GET /user_tags
  # GET /user_tags.json
  def index
    user_tags = UserTag.all
    user_tags = user_tags.where("title like ? or description like ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q]
    @user_tags = user_tags.order(params[:order] || :title).page(params[:page])
  end

  # GET /user_tags/1
  # GET /user_tags/1.json
  def show
  end

  # GET /user_tags/new
  def new
    @user_tag = UserTag.new
  end

  # GET /user_tags/1/edit
  def edit
  end

  # POST /user_tags
  # POST /user_tags.json
  def create
    @user_tag = UserTag.new(user_tag_params)

    respond_to do |format|
      if @user_tag.save
        format.html { redirect_to @user_tag, notice: 'User tag was successfully created.' }
        format.json { render :show, status: :created, location: @user_tag }
      else
        format.html { render :new }
        format.json { render json: @user_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_tags/1
  # PATCH/PUT /user_tags/1.json
  def update
    respond_to do |format|
      if @user_tag.update(user_tag_params)
        format.html { redirect_to @user_tag, notice: 'User tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_tag }
      else
        format.html { render :edit }
        format.json { render json: @user_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_tags/1
  # DELETE /user_tags/1.json
  def destroy
    @user_tag.destroy
    respond_to do |format|
      format.html { redirect_to user_tags_url, notice: 'User tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_tag
      @user_tag = UserTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_tag_params
      params.require(:user_tag).permit(:title, :description, :icon, :only_admin_can_apply, :default_apply, :mutex_ids => [])
    end
end
