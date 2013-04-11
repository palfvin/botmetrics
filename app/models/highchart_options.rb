class HighchartOptions

  attr_reader :options

  NON_HEADER_RANGE = 1..-1

  def initialize(title, rows, options = {})
    @title = title
    @rows = rows
    @options = options
    make_hash
  end

  private

  def series
    @rows[NON_HEADER_RANGE].each.collect do |row|
      {name: row[0], data: row[NON_HEADER_RANGE] }
    end
  end

  def make_hash()
    @options.update('title.text', @title) if !@options.path_exists?('title.text')
    @options.update('chart.type', 'column') if !@options.path_exists?('chart.type')
    @options.update('xAxis.categories', @rows[0][NON_HEADER_RANGE]) if !@options.path_exists?('xAxis.categories')
    @options.update('series', series) if !@options.path_exists?('series')
  end

end
