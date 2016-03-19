class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  # GET /topics
  # GET /topics.json
  def index
    redirect_to '/' if current_user && current_user.guest?
    @topics = Topic.all
  end

  # GET /topics/1
  # GET /topics/1.json
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:name)
    end
end
