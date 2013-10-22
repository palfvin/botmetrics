require 'spec_helper'

describe DashboardsController do
  it "can create dashboard" do
    user = FactoryGirl.create(:user)
    chart = FactoryGirl.create(:chart, user: user)
  end
end
