class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    comments = Comment.viewable_comments(current_user)
    comments = comments.where("title like ? or description like ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q]
    comments = comments.where(task_id: params[:task_id]) if params[:task_id]
    comments = comments.where(user_id: params[:user_id]) if params[:user_id]
    @comments = page(comments.order(params[:order] || :created_at))
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    Comment.viewable_comments(current_user).find(params[:id])
  end

  # GET /comments/new
  def new
    @comment = Comment.new
    set_task if params[:task_id]
    @comment.user = @current_user
  end

  # GET /comments/1/edit
  def edit
    if @comment.user != @current_user
      raise ApplicationController::NotAuthorized
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    set_task
    @comment.user = current_user
    unless @comment.task.viewable_by?(current_user) && @comment.task.commmentable
      raise ApplicationController::NotAuthorized
    end
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    unless @comment.editable_by?(current_user)
      raise ApplicationController::NotAuthorized
    end
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    unless @comment.editable_by?(current_user)
      raise ApplicationController::NotAuthorized
    end
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.editable_comments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:text, :data)
    end

    def set_task
      @comment.task = Task.viewable_tasks(current_user).where(commentable: true).find(params[:task_id])
    end
end
