class ChartsController < ApplicationController
  before_filter :require_authentication
  before_filter :set_chart_and_require_authorization, only: [:edit, :update, :show]

  def create
    @chart = current_user.charts.build(params[:chart])
    @chart.prepare_to_save
    if @chart.save
      flash[:success] = "Chart created"
      redirect_to @chart
    else
      render 'new'
    end
  end

  def show
  end

  def new
    @chart = Chart.new
  end

  def edit
  end

  def update
    @chart.update_attributes(params[:chart])
    @chart.prepare_to_save
    if @chart.save
      flash[:success] = "Chart updated"
      redirect_to @chart
    else
      render 'edit'
    end
  end

  private

  def set_chart_and_require_authorization
    @chart = Chart.find(params[:id])
    flash[:error] = 'Not authorized for that operation' and redirect_to(root_path) unless current_user.id==@chart.user_id
  end

end
