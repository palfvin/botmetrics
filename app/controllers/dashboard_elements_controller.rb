class DashboardElementsController < ApplicationController

  def update
    @de = DashboardElement.find(params[:id])
    puts "params are #{params.inspect}"
    if @de.update_attributes(params[:dashboard_element])
      redirect_to @de.dashboard, notice: "Successfully updated dashboard element", status: 303
    else
      redirect_to @de.dashboard, notice: "Dashboard element update failed", status: 303
    end
  end

end