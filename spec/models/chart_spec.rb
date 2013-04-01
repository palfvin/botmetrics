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

  describe "when user_id is not present" do
    before { @chart.user_id = nil }
    it { should_not be_valid}
  end

  describe "acessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Chart.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

end
