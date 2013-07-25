class ChartsController < ApplicationController
  before_filter :require_authentication
  before_filter :set_chart_and_require_authorization, only: [:edit, :update, :show, :destroy]

  def create
    @chart = current_user.charts.build(params[:chart])
    if @chart.save
      flash[:success] = "Chart created"
      redirect_to @chart
    else
      raise "Creation failure"
      render 'new'
    end
  end

  def show
    puts "Inside of show chart!!!!"
  end

  def new
    @chart = Chart.new
  end

  def edit
  end

  def destroy
    if @chart.destroy
      flash[:success] = "Chart deleted"
      redirect_to charts_user_path(current_user)
    else
      raise "Delete failure"
      render 'show'
    end
  end

  def update
    @chart.update_attributes(params[:chart])
    if @chart.save
      flash[:success] = "Chart updated"
      redirect_to @chart
    else
      raise "Update failure"
      render 'edit'
    end
  end

  private

  def set_chart_and_require_authorization
    puts "Inside of require authorization!"
    @chart = Chart.find(params[:id])
    puts "Chart id is #{@chart.id}", current_user.id, @chart.user_id
    flash[:error] = 'Not authorized for that operation' and redirect_to(root_path) unless current_user.id==@chart.user_id
  end

end
