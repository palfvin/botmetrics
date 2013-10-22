require 'spec_helper'

require 'rspec'

describe Chart do

  let(:user) { FactoryGirl.create(:user) }
  let(:chart) { user.charts.create }

  subject { chart }

  it { should respond_to(:data_source) }
  it { should respond_to(:options) }
  it { should respond_to(:javascript) }
  it { should respond_to(:user_id) }
  it { should respond_to(:table_id) }
  it { should respond_to(:name) }

  context "when user_id is not present" do
    before { chart.user_id = nil }
    it { should_not be_valid}
  end

  it "should destroy any dashboard elements when chart is destroyed" do
    dashboard = user.dashboards.create
    dashboard_element = FactoryGirl.create(:dashboard_element, chart: chart, dashboard: dashboard)
    chart.destroy
    expect {DashboardElement.find(dashboard_element.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "should unquote string keys" do
    chart.javascript = "{\"a\": 1, \"b\": 2}"
    expect(chart.javascript_plus).to  eql("{a: 1, b: 2}")
  end

  it "should unqoute functions" do
    chart.javascript = "[\"?function () {foo}?function\"]"
    expect(chart.javascript_plus).to  eql("[function () {foo}]")
  end

  # it "should unquote JavaScript functions" do
  #   chart.javascript = "{\"a\": 1, b: \"function () {}}"
  #   chart.javascript_plus = "{a: 1, b: function () {\"test\"}

end
