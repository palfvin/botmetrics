class DashboardsController < ApplicationController
  before_filter :require_authentication, only: [:edit, :update]
  before_filter :find_dashboard_and_require_authorization, only: [:edit, :update]

  def new
    @dashboard = Dashboard.new
  end

  def edit
    @dashboard = Dashboard.find(params[:id])
  end

  def show
    @dashboard = Dashboard.find(params[:id])
    @dashboard_owner = dashboard_owner?
    @skip_footer = true
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
    if @dashboard.update_attributes(params[:dashboard])
      redirect_to @dashboard, notice: "Successfully updated dashboard."
    else
      render :edit
    end
  end

  private

  def find_dashboard_and_require_authorization
    @dashboard = Dashboard.find(params[:id])
    redirect_to(root_path) unless @dashboard && dashboard_owner?
  end

  def dashboard_owner?
    current_user && current_user.id == @dashboard.user_id
  end

end
