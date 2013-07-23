require 'spec_helper'

describe "dashboards/show.html.erb" do

  before do
    @user = FactoryGirl.create(:user)
    @dashboards = (1..5).collect {|i| FactoryGirl.create(:dashboard, user: @user, name: "Dashboard #{i}") }
    @dashboard = @dashboards[0]
    @charts = (1..5).collect do |i|
      chart = FactoryGirl.create(:chart, user: @user, name: "Chart #{rand(1000)}")
      FactoryGirl.create(:dashboard_element, dashboard: @dashboard, chart: chart)
      chart
    end
    sign_in @user
  end

  subject { page }

  it "displays the My Dashboards title" do
    visit dashboards_user_path(@user)
    page.should have_content('My Dashboards')
  end


  it "displays the dashboards owned by the user" do
    visit dashboards_user_path(@user)
    @dashboards.each {|dashboard| page.should have_content(dashboard.name) }
  end

  it "displays the dashboard name" do
    visit dashboard_path(@dashboard)
    page.should have_content(@dashboard.name)
    page.should have_content(@dashboard.description)
  end

  it "lets you create a new dashboard" do
    visit dashboards_user_path(@user)
    page.should have_content("Create Dashboard")
    click_link 'Create Dashboard'
    current_path.should == new_dashboard_path
  end

end