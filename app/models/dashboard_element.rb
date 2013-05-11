class DashboardElement < ActiveRecord::Base
  belongs_to :chart
  belongs_to :dashboard
end
