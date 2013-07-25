require 'spec_helper'

describe Dashboard do

  let(:user) {FactoryGirl.create(:user)}
  let(:dashboard) {FactoryGirl.create(:dashboard, user: user)}

  subject { dashboard }

  it { should respond_to(:name) }
  it { should respond_to(:user) }
  it { should respond_to(:charts) }
  it { should respond_to(:chart_ids) }
  it { should respond_to(:description) }

  it { should be_valid }

  describe "should be invalid when no name is present" do
    before { dashboard.name = '' }
    it { should_not be_valid }
  end

  it "should destroy any contained dashboard elements" do
    chart = FactoryGirl.create(:chart)
    dashboard_element = FactoryGirl.create(:dashboard_element, dashboard: dashboard, chart: chart)
    dashboard.destroy
    expect {DashboardElement.find(dashboard_element.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

end
