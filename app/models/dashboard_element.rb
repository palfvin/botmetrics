class DashboardElement < ActiveRecord::Base
  attr_accessible :top, :left, :width, :height
  belongs_to :chart
  belongs_to :dashboard

  validates :chart_id, :presence => true
  validates :dashboard_id, presence: {message: "dashboard_id is not present", on: :update}

end
