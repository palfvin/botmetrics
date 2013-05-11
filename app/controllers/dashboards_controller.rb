class DashboardsController < ApplicationController

  def new
    @dashboard = Dashboard.new
  end

  def edit
    @dashboard = Dashboard.find(params[:id])
  end

  def show
    @dashboard = Dashboard.find(params[:id])
  end

  def create
    @dashboard = current_user.dashboards.build(params[:dashboard])
    if @dashboard.save
      redirect_to @dashboard, notice: "Successfully created dashboard."
    else
      render :new
    end
  end

  def update
    @dashboard = Dashboard.find(params[:id])
    if @dashboard.update_attributes(params[:dashboard])
      redirect_to @dashboard, notice: "Successfully updated dashboard."
    else
      render :edit
    end
  end



end
