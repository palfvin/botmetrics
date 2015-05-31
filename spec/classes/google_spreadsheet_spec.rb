require 'spec_helper'
require 'google_spreadsheet'

describe GoogleSpreadsheet do

  describe "creating a spreadsheet without mocking" do
    it 'works' do
      spreadsheet = GoogleSpreadsheet.new(mode: :write)
      expect(spreadsheet.key).to be
      puts "total spreadsheets = #{spreadsheet.account_spreadsheets.count}"
    end
  end

  describe "worksheet processing with mocked interface" do
    let(:mode) { :read }
    let(:key) { 'some key' }
    let!(:google_drive) { class_double(GoogleDrive, login_with_oauth: drive_session) }
    let!(:drive_session) { double('drive session') }
    let(:api_client) { double('ApiClient', new: OpenStruct.new) }
    let(:decrypter) { double('RSA', new: true) }
    let(:auth_client) { double('Auth Client', new: double(access_token: true, fetch_access_token!: true)) }
    let(:expected_contents) { [["Fruit Eaten", "Bananas", "Apples", "Oranges"], ["Jane", 1.0, '1973/02/01', 9.0], ["Joe", 3.0, 6.0, 8.0]] }
    let(:google_drive_rows) { [["Fruit Eaten", "Bananas", "Apples", "Oranges"], ["Jane", '1.0', '2/1/1973', '9.0'], ["Joe", '3.0', '6.0', '8.0']] }
    let(:worksheet) { double('worksheet', title: 'some sheet', rows: google_drive_rows) }
    let(:google_spreadsheet) do
      GoogleSpreadsheet.new(
          key: key,
          mode: mode,
          drive_client: google_drive,
          api_client: api_client,
          auth_client: auth_client,
          decrypter: decrypter)
    end
    before { allow(OpenSSL::PKey::RSA).to receive(:new) }

    context 'reading' do
      before { expect(drive_session).to receive_message_chain(:spreadsheet_by_key, :worksheets, :[]).and_return(worksheet) }

      it 'should return title and rows' do
        expect(google_spreadsheet.rows).to eq expected_contents
      end
    end

    context 'writing' do
      let(:mode) { :write }
      it 'creates a spreadsheet with the given key and title' do
        spreadsheet = double(key: '1234')
        expect(drive_session).to receive(:create_spreadsheet).and_return(spreadsheet)
        expect(google_spreadsheet.key).to eq('1234')
      end
    end
  end
end
