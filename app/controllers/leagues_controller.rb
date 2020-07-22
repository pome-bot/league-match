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
    @league = League.find(params[:id])

    @user_num = @league.users.length
    @users = @league.users.order(name: "ASC")
    @lusers = @league.leagues_users
    @games = @league.games.order(order: "ASC").includes(:user)

    @name_array = @league.get_name_array
    @game_user2_names = @league.get_user2_names
    @game_nones = @league.get_game_nones

    # @game_wons = @league.get_wons(@users)
    # @game_losts = @league.get_losts(@users)
    # @game_evens = @league.get_evens(@users)
    # @game_points = @league.get_points(@game_wons, @game_losts, @game_evens)
    # @game_ranks = @league.get_ranks(@game_points)
  end

  private

  def league_params
    params.require(:league).permit(:name, :group_id, user_ids: []).merge(group_id: params[:group_id])
  end

end
