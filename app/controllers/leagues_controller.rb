class LeaguesController < ApplicationController

  def index
    @groups = Group.all
    @leagues = League.all
    @users = User.all
  end

end
