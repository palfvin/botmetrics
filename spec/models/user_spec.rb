require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:id) }
  it { should respond_to(:provider) }
  it { should respond_to(:uid) }
  it { should respond_to(:charts) }

  describe "chart associations" do
    before { @user.save }
    let!(:chart1) do
      FactoryGirl.create(:chart, user: @user)
    end
    let!(:chart2) do
      FactoryGirl.create(:chart, user: @user)
    end


    it "should destroy associated charts" do
      charts = @user.charts.dup
      @user.destroy
      charts.should_not be_empty
      charts.each do |chart|
        Chart.find_by_id(chart.id).should be_nil
      end
    end
  end

end