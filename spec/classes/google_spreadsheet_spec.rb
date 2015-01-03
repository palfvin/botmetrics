require 'spec_helper'
require 'google_spreadsheet'

describe GoogleSpreadsheet do

  describe "worksheet processing" do
    let(:key) { 'some key' }
    let(:google_drive) { double('GoogleDrive') }
    let(:api_client) do
      double('Api Client',
        KeyUtils: double(load_from_pkcs12: true),
        new: OpenStruct.new)
    end
    let(:auth_client) { double('Auth Client', new: double(access_token: true, fetch_access_token!: true)) }
    let(:expected_contents) { [["Fruit Eaten", "Bananas", "Apples", "Oranges"], ["Jane", 1.0, '1973/02/01', 9.0], ["Joe", 3.0, 6.0, 8.0]] }
    let(:google_drive_rows) { [["Fruit Eaten", "Bananas", "Apples", "Oranges"], ["Jane", '1.0', '2/1/1973', '9.0'], ["Joe", '3.0', '6.0', '8.0']] }
    let(:worksheet) { double('worksheet', title: 'some sheet', rows: google_drive_rows) }
    let(:google_spreadsheet) do
      GoogleSpreadsheet.new(key, title,
        drive_client: google_drive,
        api_client: api_client,
        auth_client: auth_client)
    end

    context 'when title is not given' do
      let(:title) { nil }
      before { expect(google_drive).to receive_message_chain(:login_with_oauth, :spreadsheet_by_key, :worksheets, :[]).and_return(worksheet) }

      it 'should return title and rows' do
        expect(google_spreadsheet.rows).to eq expected_contents
        expect(google_spreadsheet.title).to eq 'some sheet'
      end
    end

    context 'when title is  given' do
      let(:title) { 'some spreadsheet' }

      before { expect(google_drive).to receive_message_chain(:login_with_oauth, :spreadsheet_by_key, :worksheet_by_title).and_return(worksheet) }

      it 'should return title and rows' do
        expect(google_spreadsheet.rows).to eq expected_contents
        expect(google_spreadsheet.title).to eq 'some sheet'
      end
    end
  end
end
