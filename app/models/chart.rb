require 'highchart_options'
require File.expand_path('../../classes/pivot_table', __FILE__)
require File.expand_path('../../classes/chart_script', __FILE__)
require File.expand_path('../../classes/hash_with_path_update', __FILE__)
require 'ostruct'


class Chart < ActiveRecord::Base
  attr_accessible :options, :data_source, :javascript, :name
  before_save :update_javascript
  belongs_to :user
  has_many :dashboard_element, dependent: :destroy

  validates :user_id, presence: true

  def refresh
    self.data = Table.get_table_info(data_source)[:rows]
  end

  def javascript_plus
    javascript.gsub(/"([^(")]+)":/, '\1:').gsub(/"\?function/, 'function').gsub(/\?function"/, '').gsub(/\\"/,'"').html_safe
  end

  def update_javascript
    return if !javascript.blank?
    table_info = if data_source.blank? then {rows: nil, title: ""}
      else
        default_to_google_source
        Table.get_table_info(data_source)
      end
    chart_script = ChartScript.new(table_info[:rows])
    chart_script.interpret(self.options)
    rows = chart_script.rows
    highchart_options = chart_script.options
    if self.name.blank?
      self.name = (highchart_options[:title][:text] if highchart_options.path_exists?('title.text')) ||
        table_info[:title]
    end
    options = HighchartOptions.new(self.name, rows, highchart_options)
    self.javascript = options.options.to_json
  end

  def default_to_google_source
    self.data_source = "Google(#{data_source})" if /^[A-Za-z0-9]+$/ =~ data_source
  end

end
