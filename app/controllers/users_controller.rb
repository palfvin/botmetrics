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
  end

  def dashboards
    @title = 'Dashboards'
    @user = User.find(params[:id])
    @dashboards = @user.dashboards
  end

end
