require 'spec_helper'
require 'google_spreadsheet'

describe GoogleSpreadsheet do

  describe "worksheet processing" do
    let(:key) { '0Ago7gICK0jzMdGhKMUdWbEV3cFgzTHd2WWxPN1Ftc2c' }
    let(:expected_contents) { [["Fruit Eaten", "Bananas", "Apples", "Oranges"], ["Jane", 1.0, 2.0, 9.0], ["Joe", 3.0, 6.0, 8.0]] }
    let(:google_drive_rows) {[["Fruit Eaten", "Bananas", "Apples", "Oranges"], ["Jane", '1.0', '2.0', '9.0'], ["Joe", '3.0', '6.0', '8.0']]}

    before :each do
      @google_drive = double('GoogleDrive')
      @worksheet = double('worksheet')
    end

    context 'when title is not given' do

      it 'should return title and rows' do
        @google_drive.stub_chain(:login, :spreadsheet_by_key, :worksheets, :[]).and_return(@worksheet);
        @worksheet.stub(:title).and_return('First Sheet')
        @worksheet.stub(:rows).and_return(google_drive_rows)
        google_spreadsheet = GoogleSpreadsheet.new(key, nil, @google_drive)
        google_spreadsheet.rows.should == expected_contents 
        google_spreadsheet.title.should == "First Sheet"
      end
    end

    context 'when title is  given' do
      let(:title) { 'Second Sheet' }

      it 'should return title and rows' do
        @google_drive.stub_chain(:login, :spreadsheet_by_key, :worksheet_by_title).and_return(@worksheet);
        @worksheet.stub(:title).and_return(title)
        @worksheet.stub(:rows).and_return(google_drive_rows)
        google_spreadsheet = GoogleSpreadsheet.new(key, title, @google_drive)
        google_spreadsheet.rows.should == expected_contents
        google_spreadsheet.title.should == title
      end
    end

  end

end