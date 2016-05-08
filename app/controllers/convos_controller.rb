class ConvosController < ApplicationController
  before_action :set_convo, only: [:show, :edit, :update, :destroy, :upvote, :downvote, :report]
  before_action :set_s3_direct_post, only: [:index, :edit, :create, :update]
  
  invisible_captcha only: [:create, :update]

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
    redirect_to :back unless current_user.can_edit?(@convo)
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def upvote
    @convo.upvote(current_user)
    render json: { message: "Successfully delivered" }, status: 201
  end
  def downvote
    @convo.downvote(current_user)
    render json: { message: "Successfully delivered" }, status: 201
  end

  def report
    @convo.report(convo_slug_path(@convo.topic.slug, @convo.id, @convo.slug))
    render json: { message: "Successfully delivered" }, status: 201
  end

  def create
    if current_user.can_post_new_convo?
      @convo = Convo.new(convo_params)
      @convo.user_id = current_user.id if current_user

      respond_to do |format|
        if @convo.save
          @convo.upvote(current_user)
          env["HTTP_REFERER"] += "?convo=#{@convo.id}"
          format.html { redirect_to :back }
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
    if current_user.can_edit?(@convo)
      @convo.destroy
    end
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
    def set_convo
      @convo = Convo.friendly.find(params[:id])
    end

    def convo_params
      params.require(:convo).permit(:convo, :author, :topic_id, :points, :by_admin)
    end

    def set_s3_direct_post
      @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
    end
end
