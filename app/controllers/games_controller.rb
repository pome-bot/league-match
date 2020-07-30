class GamesController < ApplicationController

  def create
    league_id = params[:game][:league_id]
    @league = League.find(league_id)
    users = @league.users.order(name: "ASC")
    user_num = @league.users.length
    lusers = @league.leagues_users

    @user1 = User.find(params[:game][:user_id])
    @user2 = User.find(params[:game][:user2_id])

    @score1 = game_params[:user_score]
    @score2 = game_params[:user2_score]

    if !(@user1.present? && @user2.present? && @user1 != @user2)
      @update_flag = 0
      respond_to do |format|
        format.json
        format.html {redirect_to group_league_path(@league.group_id, @league.id), alert: 'Error, select both of 2 user fields.'}
      end
    elsif (@score1.present? && !@score2.present?) || (!@score1.present? && @score2.present?)
      @update_flag = 0
      respond_to do |format|
        format.json
        format.html {redirect_to group_league_path(@league.group_id, @league.id), alert: 'Error, 2 score fields should be both filled or both empty.'}
      end
    else 
      @update_flag = 1
      gameA = @league.games.find_by(user_id: @user1.id, user2_id: @user2.id)
      gameB = @league.games.find_by(user_id: @user2.id, user2_id: @user1.id)
      if gameA.present?
        gameA.update(user_score: @score1, user2_score: @score2)
        update_leagues_users_table_5columns(@league, @user1)
        update_leagues_users_table_5columns(@league, @user2)
        update_leagues_users_rank(league_id)
      elsif gameB.present?
        gameB.update(user_score: @score2, user2_score: @score1)
        update_leagues_users_table_5columns(@league, @user1)
        update_leagues_users_table_5columns(@league, @user2)
        update_leagues_users_rank(league_id)
      end

      @users_for_table = set_users_for_table(@league, users)
      @table_rows = get_table_rows(user_num, @users_for_table, @league, lusers)

      respond_to do |format|
        format.json
        format.html {redirect_to group_league_path(@league.group_id, @league.id), notice: 'Scores was successfully updated.'}
      end
    end

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

  def update_leagues_users_rank(league_id)
    league = League.find(league_id)
    league.update_leagues_users_table_rank_temp
    # league = League.find(league_id)
    league.compare_tie_ranker_with_dif
    # league = League.find(league_id)
    league.compare_tie_ranker_with_match
  end

  def set_users_for_table(league, users)
    if league.order_flag == 0
      users_for_table = []
      league.leagues_users.order(rank: "ASC").each do |luser|
        users_for_table << luser.user
      end
    else
      users_for_table = users
    end
    return users_for_table
  end

  def get_table_rows(user_num, users_for_table, league, lusers)
    table_rows = Array.new(user_num+1) { Array.new(user_num+7) }
    table_row1 = []
    table_row1 << ""
    users_for_table.each do |user|
      table_row1 << user.name
    end
    table_row1 << "won"
    table_row1 << "lost"
    table_row1 << "draw"
    table_row1 << "point"
    table_row1 << "dif"
    table_row1 << "rank"
    table_rows[0] = table_row1
  
    users_for_table.each_with_index do |user, i|
      table_row_temp = []
      table_row_temp[0] = user.name
      users_for_table.each_with_index do |user2, j|
        if i == j
          table_row_temp[j+1] = ""
        else
          if league.get_game_scores(user.id, user2.id).present?
            table_row_temp[j+1] = league.get_game_scores(user.id, user2.id)
          else
            table_row_temp[j+1] = ""
          end
        end
      end
      table_row_temp[user_num+1] = lusers.find_by(user_id: user.id).won
      table_row_temp[user_num+2] = lusers.find_by(user_id: user.id).lost
      table_row_temp[user_num+3] = lusers.find_by(user_id: user.id).even
      table_row_temp[user_num+4] = lusers.find_by(user_id: user.id).point
      dif = lusers.find_by(user_id: user.id).difference
      dif > 0 ? dif = "+#{dif}" : dif < 0 ? dif : dif = "±0"
      table_row_temp[user_num+5] = dif
      rank = lusers.find_by(user_id: user.id).rank; rank == 0 ? "" : rank
      table_row_temp[user_num+6] = rank
      table_rows[i+1] = table_row_temp
    end
    return table_rows
  end

end
