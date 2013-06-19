class HighchartOptions

  attr_reader :options

  NON_HEADER_RANGE = 1..-1

  def initialize(title, rows, options = HashWithPathUpdate.new)
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
    if @rows
      check_for_large_tables
      append('series', series)
      check_corner_label
      set('xAxis.categories', @rows[0][NON_HEADER_RANGE])
    end
    set('title.text', @title)
  end

  private

  def check_for_large_tables
    @rows = @rows[0..10] if @rows.length > 1000
  end

  def set(path, val)
    @options.update(path, val) if !@options.path_exists?(path)
  end

  def append(path, val)
    @options.update(path, val, :append)
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
