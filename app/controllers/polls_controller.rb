class PollsController < ApplicationController
  def vote
    @poll_option = PollOption.find(params[:id])
    @poll_option.vote(current_user)
    render json: { message: "Successfully delivered" }, status: 201
  end

  private
    def poll_params
      params.require(:poll_id, :id)
    end
end
