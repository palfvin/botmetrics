require 'highchart_options'
require File.expand_path('../../classes/pivot_table', __FILE__)

class Chart < ActiveRecord::Base
  attr_accessible :options, :data_source, :javascript
  belongs_to :user

  validates :user_id, presence: true

  def generate_chart_JS
    gs = GoogleSpreadsheet.new(self.data_source)
    if match = self.options.match(/pivot (\d+) (\d+) (\d+)/)
      row_index = match.captures[1]
      column_index = match.captures[0]
      value_index = match.captures[2]
      pt = PivotTable.new(gs.rows, row_index: row_index.to_i, col_index: column_index.to_i, val_index: value_index.to_i)
      rows = pt.pivot()
    else
      rows = gs.rows
    end
    options = HighchartOptions.new(rows, {title: gs.title } )
    self.javascript = options.make_hash.to_json
  end

end
