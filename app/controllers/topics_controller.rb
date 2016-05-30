class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy, :comments]

  def show
    @title = "#{@topic.name}"
    @new_convo = Convo.new
    @new_convo.topic = @topic
    if params[:show] == 'popular'
      @convos = @topic.convos.order('weighted_score DESC').page(params[:page]).per(25)
    else
      @convos = @topic.convos.order('created_at DESC').page(params[:page]).per(25)
    end

  end

  def comments
    @comments = 
      if params[:show] == 'popular'
        Comment.find_by_topic_id(@topic).order('weighted_score DESC').page(params[:page]).per(25)
      else
        Comment.find_by_topic_id(@topic).order('created_at DESC').page(params[:page]).per(25)
      end
  end

  private
    def set_topic
      @topic = Topic.friendly.find(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:name)
    end
end
