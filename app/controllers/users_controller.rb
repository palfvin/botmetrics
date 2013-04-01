class UsersController < ApplicationController

  def new
    redirect_to '/auth/developer'
  end

  def show
  end

  def index
    @users = User.all
  end

  def charts
    @title = 'Charts'
    @user = User.find(params[:id])
    @charts = @user.charts
    render 'show_charts'
  end

end
