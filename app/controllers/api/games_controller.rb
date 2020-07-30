class Api::GamesController < ApplicationController

  def index
    league_id = params[:league_id]
    game_results = params[:game_results]
    @league = League.find(league_id)
    games = @league.games.order(order: "ASC")
    users = @league.users.order(name: "ASC")
    user_num = @league.users.length
    lusers = @league.leagues_users

    count_dif_game = 0
    game_results.each do |game_result|
      name1 = game_result[1][:user1_name]
      name2 = game_result[1][:user2_name]
      score1 = game_result[1][:user1_score]
      score2 = game_result[1][:user2_score]
      id1 = User.find_by(name: name1).id
      id2 = User.find_by(name: name2).id

      game = @league.games.find_by(user_id: id1, user2_id: id2)
      if game.user_score?
        unless game.user_score == score1.to_i && game.user2_score == score2.to_i
          count_dif_game += 1
        end
      else
        unless score1 == "" && score2 == ""
          count_dif_game += 1
        end
      end
    end

    if count_dif_game >= 1
      @update_flag = 1
      @games_for_order = []
      games.each do |game|
        name1 = game.user.name
        name2 = User.find(game.user2_id).name
        score1 = game.user_score
        score2 = game.user2_score
        @games_for_order << {name1: name1, name2: name2, score1: score1, score2: score2}
      end
      @users_for_table = set_users_for_table(@league, users)
      @table_rows = get_table_rows(user_num, @users_for_table, @league, lusers)
    else
      @update_flag = 0
      @users_for_table = nil
      @table_rows = nil
      @games_for_order = nil
    end
  end

  private

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

