class ChartScript

  attr_reader :options, :data_sources

  def initialize(data_sources = nil)
    @data_sources = if data_sources.class == Array || data_sources.nil? then
        {default: data_sources}
      else
        data_sources
    end
    @current_data_source = :default
    @options = HashWithPathUpdate.new()
  end

  def pivot(aggregator, row, col, val, headers = true)
    pivot_table = PivotTable.new(rows, row: row, col: col, val: val, headers: headers)
    self.rows = pivot_table.pivot(aggregator)
  end

  def pivot2(options = {})
    pivot_table = PivotTable.new(rows, options)
    self.rows = pivot_table.pivot(options[:aggregator])
  end

  def filter(filter_body)
    predicate = eval("lambda {|row, index| #{filter_body} }")
    (rows.length-1).downto(0) do |index|
      rows.delete_at(index) if !predicate.call(rows[index], index) rescue true
    end
  end

  def sort(sort_index, headers = true)
    sort = lambda {|row| row[sort_index]}
    if headers
      self.rows = [rows[0]]+rows.slice(1..-1).sort_by(&sort)
    else
      self.rows = rows.sort_by(&sort)
    end
  end

  def rows
    @data_sources[@current_data_source]
  end

  def set_data_source(name = :default)
    @current_data_source = name
  end

  def set(path, val)
    @options.update(path, val) ; end

  def interpret(string)
    eval(string) ; end

  private

  def rows=(value)
    @data_sources[@current_data_source] = value
  end

end

