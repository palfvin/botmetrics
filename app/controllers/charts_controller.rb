class ChartsController < ApplicationController
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
    @chart.javascript = nil
    @chart.generate_chart_JS
    if @chart.update_attributes(params[:chart])
      flash[:success] = "Chart updated"
      redirect_to @chart
    else
      render 'edit'
    end
  end

  private

  def correct_user
    @chart = Chart.find(params[:id])
    redirect_to(root_path) unless current_user.id==@chart.user_id
  end

end
