require 'spec_helper'

describe "chart page" do

  before do
    @user = FactoryGirl.create(:user)
    @chart = FactoryGirl.create(:chart, user: @user, name: 'Chart 1')
    sign_in @user
  end

  subject { page }

  it "for show displays the chart name" do
    visit chart_path(@chart)
    page.should have_content('Chart 1')
  end

  it "for edit displays the name field" do
    visit edit_chart_path(@chart)
    page.should have_field('Name')
  end

end


