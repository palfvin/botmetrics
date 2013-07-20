require 'spec_helper'

describe Chart do

  let(:user) { FactoryGirl.create(:user) }
  before do
    @chart = user.charts.build(
      data_source: 'foo')
  end

  subject { @chart }

  it { should respond_to(:data_source) }
  it { should respond_to(:options) }
  it { should respond_to(:javascript) }
  it { should respond_to(:user_id) }
  it { should respond_to(:name) }

  describe "when user_id is not present" do
    before { @chart.user_id = nil }
    it { should_not be_valid}
  end

  describe "acessible attributes" do
    it "should not allow access to user_id" do
      expect{Chart.new(user_id: user.id)}.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  it "should cache the data it retrieves" do
    table = user.tables.create(data: base_data_sample[:data])
    chart2 = user.charts.create(data_source: "Table(#{table.id})")
    chart2.refresh
    expect(chart2.data).to eq(base_data_sample[:data])
  end

end
