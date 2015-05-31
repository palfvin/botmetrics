require 'google_drive'

class GoogleSpreadsheet

  attr_reader :title, :rows

  def initialize(key: nil, mode: :read, drive_client: GoogleDrive, api_client: Google::APIClient, auth_client: Signet::OAuth2::Client, decrypter: OpenSSL::PKey::RSA)
    client = api_client.new(application_name: 'Botmetrics', application_version: '0.0.0')
    signing_key = OpenSSL::PKey::RSA.new(decrypter.new(ENV['SERVICE_ACCOUNT_SECRET_KEY'], 'notasecret'))
    readonly = '.readonly' if mode == :read
    client.authorization = auth_client.new(
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      audience: 'https://accounts.google.com/o/oauth2/token',
      scope: "https://spreadsheets.google.com/feeds https://www.googleapis.com/auth/drive#{readonly}",
      issuer: '297943685807-cabtsqb10ctf8d1aa0l892rntb9vt6ta@developer.gserviceaccount.com',
      signing_key: signing_key)
    auth = client.authorization
    auth.fetch_access_token!
    access_token = auth.access_token

    # Creates a session.
    @session = drive_client.login_with_oauth(access_token)
    case mode
      when :read
        @spreadsheet = @session.spreadsheet_by_key(key)
        worksheet = @spreadsheet.worksheets[0]
        @rows = recognize_and_convert_numbers(worksheet.rows)
      when :write
        @spreadsheet = @session.create_spreadsheet
    end
  end

  def account_spreadsheets
    @session.spreadsheets
  end

  def key
    @spreadsheet.key
  end

  private

  def recognize_and_convert_numbers(array_of_arrays)
    array_of_arrays.collect do |array|
      array.collect do |value|
        if is_number_format(value)
          value.to_f
        elsif is_date_format(value)
          Date.strptime(value, '%m/%d/%Y').strftime('%Y/%m/%d')
        elsif value == ''
          nil
        else
          value
        end
      end
    end
  end

  def is_number_format(value)
    value.match(/\A[+-]?\d+?(\.\d+)?\Z/) != nil
  end

  def is_date_format(value)
    value.match(/\A[\d]{1,2}\/[\d]{1,2}\/[\d]{2,4}\Z/)
  end

end


