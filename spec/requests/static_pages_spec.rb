require 'spec_helper'

describe "Static Pages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_selector('h1', text: 'Track your world!') }

  end

end
