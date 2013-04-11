require 'highchart_options'
require File.expand_path('../../classes/pivot_table', __FILE__)
require File.expand_path('../../classes/chart_script', __FILE__)
require File.expand_path('../../classes/hash_with_path_update', __FILE__)


class Chart < ActiveRecord::Base
  attr_accessible :options, :data_source, :javascript
  belongs_to :user

  validates :user_id, presence: true

  def generate_chart_JS
    gs = GoogleSpreadsheet.new(self.data_source)
    chart_script = ChartScript.new(gs.rows)
    chart_script.interpret(self.options)
    rows = chart_script.rows
    highchart_options = chart_script.options
    options = HighchartOptions.new(gs.title, rows, highchart_options)
    self.javascript = options.options.to_json
  end

end
