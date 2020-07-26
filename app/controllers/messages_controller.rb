class MessagesController < ApplicationController

  def create
    league_id = params[:message][:league_id]
    league = League.find(league_id)

    message = Message.new(message_params)
    if message.save
      redirect_to group_league_path(league.group_id, league.id)
    else
      redirect_to group_league_path(league.group_id, league.id)
    end
  end

  private

  def message_params
    params.require(:message).permit(:text).merge(league_id: params[:message][:league_id], user_id: current_user.id)
  end

end
