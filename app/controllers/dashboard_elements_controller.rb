class DashboardElementsController < ApplicationController
  before_filter :require_authentication
  
  def update
    @de = DashboardElement.find(params[:id])
    if current_user.id != Dashboard.find(@de.dashboard_id).user_id
      redirect_to root_path, notice: "Not authorized for that operation", status: 303
    elsif @de.update_attributes(params[:dashboard_element])
      redirect_to @de.dashboard, notice: "Successfully updated dashboard element", status: 303
    else
      redirect_to @de.dashboard, notice: "Dashboard element update failed", status: 303
    end
  end

end