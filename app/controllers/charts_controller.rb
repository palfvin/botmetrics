class ChartsController < ApplicationController
  before_filter :require_login
  before_filter :correct_user, only: [:edit, :update]

  def create
    @chart = current_user.charts.build(params[:chart])
    @chart.generate_chart_JS
    if @chart.save
      flash[:success] = "Chart created"
      redirect_to @chart
    else
      render 'new'
    end
  end

  def show
    @chart = Chart.find(params[:id])
  end

  def new
    @chart = Chart.new
  end

  def edit
    @chart = Chart.find(params[:id])
  end

  def update
    @chart.update_attributes(params[:chart])
    @chart.generate_chart_JS
    if @chart.save
      flash[:success] = "Chart updated"
      redirect_to @chart
    else
      render 'edit'
    end
  end

  private

 def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to signin_path # halts request cycle
    end
  end

  def correct_user
    @chart = Chart.find(params[:id])
    redirect_to(root_path) unless current_user.id==@chart.user_id
  end

end
