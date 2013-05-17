class DashboardElementsController < ApplicationController

  def update
    @de = DashboardElement.find(params[:id])
    if @de.update_attributes(params[:dashboard_element])
      redirect_to @de.dashboard, notice: "Successfully updated dashboard element"
    else
      redirect_to @de.dashboard, notice: "Dashboard element update failed"
    end
  end

end