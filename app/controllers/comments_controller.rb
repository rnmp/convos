class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :upvote, :downvote, :report]
  
  invisible_captcha only: [:create, :update]

  def index
    @comments = 
      if params[:show] == 'popular'
        Comment.order('weighted_score DESC').page(params[:page]).per(25)
      else
        Comment.order('created_at DESC').page(params[:page]).per(25)
      end
  end

  def edit
    redirect_to :back unless current_user.can_edit?(@comment)
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def create
    @reply_notification = Notification.new

    if params[:comment][:parent_id].to_i > 0
      parent = Comment.find_by_id(params[:comment].delete(:parent_id))
      @comment = parent.children.build(comment_params)
      @reply_notification.user_id = parent.user_id
    else
      @comment = Comment.new(comment_params)
      @reply_notification.user_id = @comment.convo.user_id
    end
    @comment.user_id = current_user.id if current_user

    respond_to do |format|
      if @comment.save
        @convo = @comment.convo

        @comment.upvote(current_user)

        redirect_path = convo_slug_path(@convo.topic.slug, @convo.id, @convo.slug, anchor: "comment-#{@comment.id}")

        @reply_notification.message = \
          "someone replied to your #{ @comment.parent_id ? 'comment on' : 'convo' } <a href='#{redirect_path}'>"\
          "#{@comment.convo.title}</a>.".html_safe
        @reply_notification.save unless @reply_notification.user_id == current_user.id

        @commenters = @comment.convo.commenters - [current_user, @comment.convo.user]
        if @commenters.any? && @comment.parent_id.nil?
          @commenters.each do |commenter|
            Notification.create(
              user: commenter,
              message:  \
                "someone also commented on <a href='#{redirect_path}'>"\
                "#{@comment.convo.title}</a>.".html_safe
              )
          end
        end

        format.html { redirect_to redirect_path }
        format.json { render :show, status: :created, location: @comment }
      end
    end
  end

  def upvote
    @comment.upvote(current_user)
    render json: { message: "Successfully delivered" }, status: 201
  end
  def downvote
    @comment.downvote(current_user)
    render json: { message: "Successfully delivered" }, status: 201
  end

  def report
    @comment.report(convo_slug_path(@comment.convo.topic.slug, @comment.convo.id, @comment.convo.slug, anchor: "comment-#{@comment.id}"))
    render json: { message: "Successfully delivered" }, status: 201
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.edited = true
    
    if @comment.update(comment_params)
      redirect_to convo_path(@comment.convo)
    else
      render 'edit'
    end 
  end

  def destroy
    if current_user.can_edit?(@comment)
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
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:author, :comment, :convo_id, :parent_id, :points, :by_admin)
    end
end
