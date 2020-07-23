class UsersController < ApplicationController

  def index
    return nil if params[:keyword] == ""
    # group = Group.find(params[:group_id])

    if false
      usersA = User.all.where.not(id: current_user.id).order(name: "ASC").limit(10)
      usersB = User.where(id: params[:user_ids])
      @users = usersA - usersB
    else
      usersA = User.where(['name LIKE ?', "%#{params[:keyword]}%"]).where.not(id: current_user.id).order(name: "ASC").limit(10)
      usersB = User.where(id: params[:user_ids])
      @users = usersA - usersB
    end
  end

  def show
  end

end
