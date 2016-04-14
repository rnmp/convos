class ReportsController < ApplicationController
  before_action :set_params
  def create
    if params[:type] == 'convo'
      @item = Convo.find(params[:id])
      redirect_path = convo_slug_path(@item.topic.slug, @item.id, @item.slug)
    elsif params[:type] == 'comment'
      @item = Comment.find(params[:id])
      redirect_path = convo_slug_path(@item.convo.topic.slug, @item.convo.id, @item.convo.slug, anchor: "comment-#{@item.id}")
    end

    @admins = User.admins
    @admins.each do |admin|
      @notification = Notification.new(message: 
        "Someone reported <a href='#{redirect_path}' target='_blank'>a #{params[:type]}</a>.".html_safe)
      @notification.user_id = admin.id
      @notification.save
      respond_to do |format|
        msg = { status: "ok", message: "Success!", html: "Success" }
        format.json { render json: msg }
      end
      return
    end
  end
  private
    def set_params
      params.permit(:type, :id)
    end
end
