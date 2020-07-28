class MessagesController < ApplicationController

  def create
    league_id = params[:message][:league_id]
    @league = League.find(league_id)
    @message = @league.messages.new(message_params)

    if @message.save
      respond_to do |format|
        format.json
      end
    else
      respond_to do |format|
        format.json {render plain: "dummy"}
        # format.json {render plain: '{"name":"a"}'}
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:text).merge(user_id: current_user.id)
  end

end
