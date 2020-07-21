class GroupsController < ApplicationController

  def index
    @groups = current_user.groups.order(created_at: "DESC")
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to group_leagues_path(@group.id) # ,notice: 'グループを作成しました'
    else
      render :new
    end
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to group_leagues_path(@group.id) # ,notice: 'グループを更新しました'
    else
      render :edit
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, user_ids: [])
  end
  
end
