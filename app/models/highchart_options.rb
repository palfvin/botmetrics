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
    set('title.text', @title)
    set('xAxis.categories', @rows[0][NON_HEADER_RANGE])
    set('series', series)
    check_corner_label
  end

  def set(path, val)
    @options.update(path, val) if !@options.path_exists?(path)
  end

  def corner
    @rows[0][0] ; end

  def check_corner_label
    if corner && (match = corner.match(/([^(]*)\(([^\\]*)\\([^\\]*)\)/))
      set('xAxis.title.text', match.captures[2].strip)
      set('yAxis.title.text', match.captures[0].strip)
    end
  end

end
