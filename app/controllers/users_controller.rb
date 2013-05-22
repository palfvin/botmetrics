class UsersController < ApplicationController

  before_filter :require_authentication, except: [:new]
  before_filter :require_admin, only: [:index]
  before_filter :require_authorization, only: [:show, :charts, :dashboards]

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

  private

  def require_authorization
    unless current_user.id == params[:id].to_i
      flash['Not authorized to perform that operation']
      redirect_to root_path
    end
  end

end
