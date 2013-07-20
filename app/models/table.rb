class Table < ActiveRecord::Base
  attr_accessible :data_source, :data, :name
  belongs_to :user
  before_save :get_and_save_data
  serialize :data
  validates_uniqueness_of :name

  validates :user_id, presence: true

  def refresh
    self.data = self.class.get_table_info(data_source)[:rows]
    self.save
  end

  def get_and_save_data
    if !data_source.blank? and data.blank?
      table_info = Table.get_table_info(data_source)
      self.data = table_info[:rows]
    end
  end

  def self.get_table_info(specification)
    raise "Bad table data_source specification" unless /^(Google|Table)\(([^)]*)\)$/ =~ specification
    type, key = $1, $2
    case type
    when 'Google'
      spreadsheet = GoogleSpreadsheet.new(key)
      rows, title = spreadsheet.rows, spreadsheet.title
    when 'Table'
      table = self.find(key)
      rows, title = table.data, table.name
    end
    {rows: rows, title: title}
  end

end
