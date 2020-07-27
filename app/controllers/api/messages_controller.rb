class Api::MessagesController < ApplicationController
  def index
    league_id = params[:league_id]
    league = League.find(league_id)
    last_message_id = params[:id]
    @messages = league.messages.includes(:user).where("id > ?", last_message_id)
  end
end
