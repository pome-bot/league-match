class GamesController < ApplicationController

  def create
    @league = League.find(params[:game][:league_id])

    user = User.find_by(name: params[:game][:user_name])
    user2 = User.find_by(name: params[:game][:user2_name])

    unless user.present? && user2.present? && user != user2 && params[:game][:user_score].present? && params[:game][:user2_score].present?
      # set error messages
    else 
      gameA = @league.games.where(user_id: user.id).find_by(user2_id: user2.id)
      gameB = @league.games.where(user_id: user2.id).find_by(user2_id: user.id)
      
      if gameA.present?
        gameA.update(game_params)
      elsif gameB.present?
        gameB.update(user_score: game_params[:user2_score], user2_score: game_params[:user_score])
      end
    end

    redirect_to group_league_path(@league.group_id, @league.id)
  end

  private

  def game_params
    params.require(:game).permit(:user_score, :user2_score)
  end

end
