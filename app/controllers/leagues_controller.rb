class LeaguesController < ApplicationController

  def index
    @group = Group.find(params[:group_id])
    @leagues = @group.leagues.order(created_at: "DESC").includes(:users)
    @users = @group.users.order(name: "ASC")
  end

  def new
    @group = Group.find(params[:group_id])
    @users = @group.users.order(name: "ASC")
    @league = League.new
    @league.users << @group.users.order(name: "ASC")
  end

  def edit
    @group = Group.find(params[:group_id])
    @league = League.find(params[:id])
    @users = @league.users.order(name: "ASC")
  end

  def create
    @group = Group.find(params[:group_id])
    @league = League.new(league_params)
    @users = @group.users.order(name: "ASC")

    if @league.users.length <= 1
      @error_msg = "League members should be no less than 2."
      render :new
    elsif @league.save
      @league.create_games(@group)
      redirect_to group_league_path(@league.group_id, @league.id), notice: 'League was successfully created.'
    else
      render :new
    end
  end

  def update
    @group = Group.find(params[:group_id])

    @league = League.find(params[:id])
    @users = @league.users

    if @league.users.length <= 1
      render :edit
    elsif @league.update(league_params_update)
      @users.each do |user|
        update_leagues_users_table_5columns(@league, user)
      end
      update_leagues_users_rank(@league.id)
      redirect_to group_league_path(@league.group_id, @league.id), notice: 'League was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    league = League.find(params[:id])
    league.destroy
    redirect_to group_leagues_path(league.group_id), notice: 'League was successfully deleted.'
  end

  def show
    @game = Game.new
    @message = Message.new
    @group = Group.find(params[:group_id])
    league_id = params[:id]
    @league = League.find(league_id)

    @user_num = @league.users.length
    @users = @league.users.order(name: "ASC")
    @users_for_table = set_users_for_table(@league, @users)
    @lusers = @league.leagues_users
    @games = @league.games.order(order: "ASC").includes(:user)

    @game_user2_names = @league.get_user2_names
    @game_nones = @league.get_game_nones
  end

  private

  def league_params
    params.require(:league).permit(:name, user_ids: []).merge(group_id: params[:group_id])
  end

  def league_params_update
    params.require(:league).permit(:name, :win_point, :lose_point, :even_point, :order_flag).merge(group_id: params[:group_id])
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

end
