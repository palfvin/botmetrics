require 'spec_helper'

describe Dashboard do
  
  before do
    @user = FactoryGirl.create(:user)
    @dashboard = FactoryGirl.create(:dashboard, user: @user)
  end

  subject { @dashboard }

  it { should respond_to(:name) }
  it { should respond_to(:user) }
  it { should respond_to(:charts) }
  it { should respond_to(:chart_ids) }
  it { should respond_to(:description) }

  it { should be_valid }

  describe "should be invalid when no name is present" do
    before { @dashboard.name = '' }
    it { should_not be_valid }
  end

end
