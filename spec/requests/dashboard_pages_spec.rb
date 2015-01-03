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
    expect(page).to have_content('My Dashboards')
  end


  it "displays the dashboards owned by the user" do
    visit dashboards_user_path(@user)
    @dashboards.each {|dashboard| expect(page).to have_content(dashboard.name) }
  end

  it "displays the dashboard name" do
    visit dashboard_path(@dashboard)
    expect(page).to have_content(@dashboard.name)
    expect(page).to have_content(@dashboard.description)
  end

  context "creating a nwe dashboard" do

    before { visit dashboards_user_path(@user) }
    let(:click) { click_link 'Create Dashboard' }

    it "shows Create Dashboard link" do
      expect(page).to have_content("Create Dashboard")
    end

    it "clicking takes you to the new_dashboard_path" do
      click
      expect(current_path).to eq new_dashboard_path
    end

    it "lets you create a new dashboard with a chart" do
      click
      fill_in 'dashboard_name', with: "New Dashboard"
      chart_name = @charts[0].name
      check chart_name
      click_button 'Create Dashboard'
      click_link 'New Dashboard'
      expect(page).to have_checked_field(chart_name)
    end

  end

end
