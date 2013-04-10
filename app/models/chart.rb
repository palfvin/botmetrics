require 'highchart_options'
require File.expand_path('../../classes/pivot_table', __FILE__)
require File.expand_path('../../classes/chart_script', __FILE__)


class Chart < ActiveRecord::Base
  attr_accessible :options, :data_source, :javascript
  belongs_to :user

  validates :user_id, presence: true

  def generate_chart_JS
    gs = GoogleSpreadsheet.new(self.data_source)
    rows = gs.rows
    params = { title: gs.title }
    if self.options != ""
      chart_script = ChartScript.new(rows)
      chart_script.interpret(self.options)
      rows = chart_script.rows
      params.merge!(chart_script.options)
      puts params.inspect
    end
    options = HighchartOptions.new(rows, params)
    self.javascript = options.make_hash.to_json
  end

end
