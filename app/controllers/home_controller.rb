class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:top, :about, :signout]

  def top
  end

  def about
  end

  def signout
  end

end
