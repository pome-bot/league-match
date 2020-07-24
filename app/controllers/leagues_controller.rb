class LeaguesController < ApplicationController

  def new
    @group = Group.find(params[:group_id])
    @users = @group.users.order(name: "ASC")
    @league = League.new
    @league.users << @group.users.order(name: "ASC")
  end

  def index
    @group = Group.find(params[:group_id])
    @leagues = @group.leagues.order(created_at: "DESC").includes(:users)
    @users = @group.users.order(name: "ASC")
  end

  def create
    @group = Group.find(params[:group_id])
    @league = League.new(league_params)
    @users = @group.users.order(name: "ASC")

    if @league.users.length <= 1
      render :new
    elsif @league.save
      @league.create_games(@group)
      redirect_to group_league_path(@league.group_id, @league.id)
    else
      render :new
    end
  end

  def show
    @game = Game.new
    @group = Group.find(params[:group_id])
    league_id = params[:id]

    # league = League.find(league_id)
    # league.users.each do |user|
    #   update_leagues_users_table_5columns(league, user)
    # end
    # update_leagues_users_rank(league_id)

    @league = League.find(league_id) # reset

    @user_num = @league.users.length
    @users = @league.users.order(name: "ASC")
    @lusers = @league.leagues_users
    @games = @league.games.order(order: "ASC").includes(:user)

    @name_array = @league.get_name_array
    @game_user2_names = @league.get_user2_names
    @game_nones = @league.get_game_nones
  end

  private

  def league_params
    params.require(:league).permit(:name, :group_id, user_ids: []).merge(group_id: params[:group_id])
  end

  # def update_leagues_users_table_5columns(league, user)
  #   luser = league.leagues_users.find_by(user_id: user.id)
  #   luser_won = league.get_won_count(user.id)
  #   luser_even = league.get_even_count(user.id)
  #   luser_lost = league.get_lost_count(user.id)
  #   luser_point = luser_won * league.win_point + luser_even * league.even_point + luser_lost * league.lose_point 
  #   luser_dif = league.get_difference(user.id)
  #   luser.update(won: luser_won, lost: luser_lost, even: luser_even, point: luser_point, difference: luser_dif)
  # end

  # def update_leagues_users_rank(league_id)
  #   league = League.find(league_id)
  #   league.update_leagues_users_table_rank_temp
  #   league = League.find(league_id)
  #   league.compare_tie_ranker_with_dif
  #   league = League.find(league_id)
  #   league.compare_tie_ranker_with_match
  # end

end
