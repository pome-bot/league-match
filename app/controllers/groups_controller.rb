class GroupsController < ApplicationController

  def index
    @groups = current_user.groups
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

end
