require 'google_drive'

class GoogleSpreadsheet

  attr_reader :title, :rows

  def initialize(key, title = nil, source = GoogleDrive)
    session = source.login(ENV['GOOGLE_NAME'], ENV['GOOGLE_PASSWORD'])
    spreadsheet = session.spreadsheet_by_key(key)
    worksheet = title ? spreadsheet.worksheet_by_title(title) : spreadsheet.worksheets[0]
    @title = worksheet.title
    @rows = recognize_and_convert_numbers(worksheet.rows)
  end

  private

  def recognize_and_convert_numbers(array_of_arrays)
    array_of_arrays.collect do |array|
      array.collect do |value|
        if is_number_format(value)
          value.to_f
        elsif is_date_format(value)
          Date.strptime(value,'%m/%d/%Y').strftime('%Y-%m-%d')
        else value
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


