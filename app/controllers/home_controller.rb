class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:top, :about, :signout]
  before_action :check_signed_in, only: [:top, :about, :signout]

  def top
  end

  def about
  end

  def signout
  end

  private

  def check_signed_in
    if user_signed_in?
      redirect_to groups_path
    end
  end

end
