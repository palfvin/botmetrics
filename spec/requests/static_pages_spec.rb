require 'spec_helper'

describe "Static Pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it "should have herald" do
      herald = page.find('h1')
      herald.should have_content('Track your world!')
    end

    describe "after login" do
      before do
        @user = FactoryGirl.create(:user)
        sign_in(@user)
      end

      it { should have_link('Charts')  }
      it { should have_link('Dashboards') }
      it { should have_link('Tables') }

      it "should go to About page" do
        click_link 'About'
      end

    end

  end

end
