class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :upvote, :downvote]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.search(params[:search]).page(params[:page]).per(25)
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new(parent_id: params[:parent_id], convo_id: params[:convo_id])
  end

  # GET /comments/1/edit
  def edit
    redirect_to :back unless @comment.user && @comment.user == current_user
  end

  # POST /comments
  # POST /comments.json
  def create
    if params[:comment][:parent_id].to_i > 0
      parent = Comment.find_by_id(params[:comment].delete(:parent_id))
      @comment = parent.children.build(comment_params)
    else
      @comment = Comment.new(comment_params)
    end
    @comment.user_id = current_user.id if current_user

    respond_to do |format|
      if @comment.save
        @convo = @comment.convo
        @comment.upvote(current_user)
        format.html { redirect_to convo_path(@convo, anchor: "comment-#{@comment.id}") }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def upvote
    @comment.upvote(current_user)
    redirect_to :back
  end
  def downvote
    @comment.downvote(current_user)
    redirect_to :back
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    
    if @comment.update(comment_params)
      redirect_to :back
    else
      render 'edit'
    end 
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if @comment.user && @comment.user = current_user
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { head :no_content }
      end
    else
      redirect_to :back
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:author, :comment, :convo_id, :parent_id, :points)
    end
end
