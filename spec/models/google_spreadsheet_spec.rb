require 'spec_helper'
require 'google_spreadsheet'

describe GoogleSpreadsheet do

  describe "it should process the worksheets correctly" do
    let(:key) { '0Ago7gICK0jzMdGhKMUdWbEV3cFgzTHd2WWxPN1Ftc2c' }
    let(:expected_contents) { [["Fruit Eaten", "Bananas", "Apples", "Oranges"], ["Jane", 1.0, 2.0, 9.0], ["Joe", 3.0, 6.0, 8.0]] }

    context 'should get read the first worksheet when no title is given' do
      subject(:spreadsheet) { GoogleSpreadsheet.new(key) }

      its(:rows) { should == expected_contents }
      its(:title) { should == "First Sheet" }
    end

    context "should get the second worksheet by name" do
      let(:title) { 'Second Sheet' }

      subject(:spreadsheet) { GoogleSpreadsheet.new(key, title) }

      its(:rows) { should == expected_contents }
      its(:title) { should == title }
    end

  end

end