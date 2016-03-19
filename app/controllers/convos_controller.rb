class ConvosController < ApplicationController
  before_action :set_convo, only: [:show, :edit, :update, :destroy, :upvote, :downvote]

  def index
    @new_convo = Convo.new

    if params[:show] == 'popular'
      @convos = Convo.order('weighted_score DESC').page(params[:page]).per(25)
    else
      @convos = Convo.order('created_at DESC').page(params[:page]).per(25)
    end
    if params[:search]
      @title = "search results for #{params[:search]}"
      @convos = Convo.search(params[:search]).order('created_at DESC').page(params[:page]).per(25)
    end
  end

  def show
    if params[:show].present?
      if params[:show] == 'recent'
        @comments_order = 'created_at'
      end
    else
      @comments_order = 'weighted_score'
    end
    @comments = @convo.comments.hash_tree
    @comment = Comment.new(convo: @convo)
    @comment_to_comment = Comment.new(convo: @convo, parent_id: params[:parent_id])
  end

  def edit
    redirect_to :back unless @convo.user && @convo.user == current_user
  end

  def upvote
    @convo.upvote(current_user)
    redirect_to :back
  end
  def downvote
    @convo.downvote(current_user)
    redirect_to :back
  end

  def create
    if current_user.can_post_new_convo?
      @convo = Convo.new(convo_params)
      @convo.user_id = current_user.id if current_user

      respond_to do |format|
        if @convo.save
          @convo.upvote(current_user)
          format.html { redirect_to :back, notice: @convo.id }
          format.json { render :show, status: :created, location: @convo }
        else
          format.html { render :new }
          format.json { render json: @convo.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path
    end
  end

  def update
    @convo.edited = true
    
    if @convo.update(convo_params)
      redirect_to @convo
    else
      render 'edit'
    end 
  end

  def destroy
    if @convo.user && @convo.user = current_user
      @convo.destroy
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    def set_convo
      @convo = Convo.friendly.find(params[:id])
    end

    def convo_params
      params.require(:convo).permit(:convo, :author, :topic_id, :points)
    end
end
