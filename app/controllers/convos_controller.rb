require 'open-uri'
class ConvosController < ApplicationController
  before_action :set_convo, only: [:show, :edit, :update, :destroy, :upvote, :downvote, :report]
  
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

          @twitter_bot = Twitter::REST::Client.new do |config|
            config.consumer_key        = "vx8fJAq7WNny2LS773rJAeBEo"
            config.consumer_secret     = "z1IrJON5ziI9lqfjiiGKtGXVH8RdC4OhPAN6OF8ZBQnPHRiTbt"
            config.access_token        = "712122829186199553-jOcB1dH7IuVNm9c55BtLMrubvrLdHrZ"
            config.access_token_secret = "q1HvqWYj0i4iYGHJ3klORo24jzbx2e7IYusill96yr7cp"
          end

          @twitter_bot.update(@convo.to_tweet)

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
end
