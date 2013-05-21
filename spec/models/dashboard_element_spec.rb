require 'spec_helper'

describe DashboardElement do

  before do
    @user = FactoryGirl.create(:user)
    @chart = FactoryGirl.create(:chart, user: @user)
    @dashboard = FactoryGirl.create(:dashboard, user: @user)
    @de = FactoryGirl.create(:dashboard_element, chart: @chart, dashboard: @dashboard)
  end

  subject { @de }

  it { should respond_to(:dashboard) }
  it { should respond_to(:chart) }
  it { should respond_to(:top) }
  it { should respond_to(:left) }
  it { should respond_to(:width) }
  it { should respond_to(:height) }

  it { should be_valid }

  describe "should be invalid if dashboard is not present" do
    before { @de.dashboard = nil }
    it { should_not be_valid }
  end

  describe "should be invalid if dashboard is not present" do
    before { @de.chart = nil }
    it { should_not be_valid }
  end

end
