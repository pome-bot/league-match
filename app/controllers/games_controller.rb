class GamesController < ApplicationController

  def create
    league = League.find(params[:game][:league_id])

    user1 = User.find_by(name: params[:game][:user_name])
    user2 = User.find_by(name: params[:game][:user2_name])

    score1 = game_params[:user_score]
    score2 = game_params[:user2_score]

    unless user1.present? && user2.present? && user1 != user2 && score1.present? && score2.present?
      # set error messages
    else 
      gameA = league.games.where(user_id: user1.id).find_by(user2_id: user2.id)
      gameB = league.games.where(user_id: user2.id).find_by(user2_id: user1.id)
      if gameA.present?
        gameA.update(user_score: score1, user2_score: score2)
        update_leagues_users_table_5columns(league, user1)
        update_leagues_users_table_5columns(league, user2)
        league.update_leagues_users_table_rank_temp
    

      elsif gameB.present?
        gameB.update(user_score: score2, user2_score: score1)
        update_leagues_users_table_5columns(league, user1)
        update_leagues_users_table_5columns(league, user2)
        league.update_leagues_users_table_rank_temp


      end
    end

    redirect_to group_league_path(league.group_id, league.id)
  end

  private

  def game_params
    params.require(:game).permit(:user_score, :user2_score)
  end

  def update_leagues_users_table_5columns(league, user)
    luser = league.leagues_users.find_by(user_id: user.id)
    luser_won = league.get_won_count(user.id)
    luser_even = league.get_even_count(user.id)
    luser_lost = league.get_lost_count(user.id)
    luser_point = luser_won * league.win_point + luser_even * league.even_point + luser_lost * league.lose_point 
    luser_dif = league.get_difference(user.id)
    luser.update(won: luser_won, lost: luser_lost, even: luser_even, point: luser_point, difference: luser_dif)
  end

end
