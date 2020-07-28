class UsersController < ApplicationController
  before_action :check_current_user?, only: :show

  def index
    return nil if params[:keyword] == ""
    # group = Group.find(params[:group_id])

    if false
      # challenge sub query!
    else
      usersA = User.where(['name LIKE ?', "%#{params[:keyword]}%"]).where.not(id: current_user.id).order(name: "ASC").limit(10)
      usersB = User.where(id: params[:user_ids])
      @users = usersA - usersB
    end
  end

  def show
    @user = User.find(params[:id])
    @groups = @user.groups.order(created_at: "DESC")
    @leagues = @user.leagues.order(created_at: "DESC")
    @lusers = @user.leagues_users
    if @lusers.order(rank: "DESC").present?
      @rank_max = @lusers.order(rank: "DESC").limit(1)[0].rank
    else
      @rank_max = 0
    end
  end

  private

  def check_current_user?
    if params[:id].to_i != current_user.id
      redirect_to user_path(current_user.id)
    end
  end

end
