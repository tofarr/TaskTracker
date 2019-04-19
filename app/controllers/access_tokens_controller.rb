class AccessTokensController < ApplicationController
  before_action :set_access_token, only: [:show, :edit, :update, :destroy]

  # GET /access_tokens
  # GET /access_tokens.json
  def index
    @access_tokens = page(access_token_list)
  end

  # GET /access_tokens/1
  # GET /access_tokens/1.json
  def show
  end

  # GET /access_tokens/new
  def new
    @model = AccessToken.new
    @model.user = current_user
  end

  # GET /access_tokens/1/edit
  def edit
  end

  # POST /access_tokens
  # POST /access_tokens.json
  def create
    @model = AccessToken.new(access_token_params)
    @model.user = current_user

    respond_to do |format|
      if @model.save
        format.html { redirect_to @model, notice: 'Access token was successfully created.' }
        format.json { render :show, status: :created, location: @model }
      else
        format.html { render :new }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /access_tokens/1
  # PATCH/PUT /access_tokens/1.json
  def update
    respond_to do |format|
      if @model.update(access_token_params)
        format.html { redirect_to @model, notice: 'Access token was successfully updated.' }
        format.json { render :show, status: :ok, location: @model }
      else
        format.html { render :edit }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /access_tokens
  # PATCH /access_tokens.json
  def update_all
    #Build a json file based on criteria and settings...
    @access_token_job = BatchJob::AccessTokenUpsertJob.new(user: current_user)

    prepare_job(@access_token_job) do |access_token_job|
      attach_params_as_file_to_upsert_job(access_token_job)
    end

    @access_tokens = page(access_token_list)

    if @access_token_job.save
      BatchProcessorJob.perform_later(@access_token_job.id, @current_user.id)
      respond_to do |format|
        format.html { redirect_to :access_tokens, notice: 'Batch Job Submitted.' }
        format.json { render :show, status: :ok, location: url_for(controller: "", action: "update_all") }
      end
    else
      respond_to do |format|
        format.html { render :access_tokens }
        format.json { render json: @access_token_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /access_tokens/1
  # DELETE /access_tokens/1.json
  def destroy
    @model.destroy
    respond_to do |format|
      format.html { redirect_to access_tokens_url, notice: 'Access token was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # DELETE /access_tokens
  # DELETE /access_tokens.json
  def destroy_all
    @access_token_job = BatchJob::AccessTokenDestroyJob.new(user: current_user)

    prepare_job(@access_token_job) do |access_token_job|
      all_access_token_updates = access_token_list.select(:id).map do |access_token|
        access_token.as_json.slice("id")
      end
      access_token_job.data.attach(io: StringIO.new(all_access_token_updates.to_json), content_type: "application/json", filename: "upload.json")
    end

    if @access_token_job.save
      BatchProcessorJob.perform_later(@access_token_job.id, @current_user.id)
      respond_to do |format|
        format.html { redirect_to :access_tokens, notice: 'Batch Job Submitted.' }
        format.json { render :show, status: :ok, location: url_for(controller: "", action: "update_all") }
      end
    else
      respond_to do |format|
        format.html { render :access_tokens }
        format.json { render json: @access_token_job.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_access_token_search
      user_search
    end

    def access_token_search
      @access_token_search ||= Search::Search.new(params[:access_token_search]&.permit!&.to_h&.symbolize_keys)
    end

    def access_token_list(force_order = false)
      @access_tokens ||= access_token_search.filter(current_user.access_tokens, force_order)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_access_token
      @model = current_user.access_tokens.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def access_token_params
      params.require(:access_token).permit(:title, :token, :read_only, :expires_at, :suspended)
    end

    def attach_params_as_file_to_upsert_job(job)
      updates = AppUtils.collapse(params.require(:access_token).permit(:read_only, :expires_at, :suspended).to_h) || {}
      access_tokens = access_token_list
      all_access_token_updates = access_tokens.map do |access_token|
        updates.clone.merge(id: access_token.id)
      end
      job.data.attach(io: StringIO.new(all_access_token_updates.to_json), content_type: "application/json", filename: "upload.json")
    end
end
