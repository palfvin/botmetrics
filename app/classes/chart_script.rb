class ChartScript

  attr_reader :rows, :options

  def initialize(rows)
    @rows = rows
    @options = HashWithPathUpdate.new()
  end

  def pivot(aggregator, row, col, val, headers = true)
    pivot_table = PivotTable.new(@rows, row_index: row, col_index: col, val_index: val, headers: headers)
    @rows = pivot_table.pivot(aggregator)
  end

  def filter(filter_body)
    predicate = eval("lambda {|row| #{filter_body} }")
    (@rows.length-1).downto(0) do |index|
      @rows.delete_at(index) if !predicate.call(@rows[index]) rescue true
    end
  end

  def sort(sort_index, headers = true)
    sort = lambda {|row| row[sort_index]}
    if headers
      @rows = [@rows[0]]+@rows.slice(1..-1).sort_by(&sort)
    else
      @rows = @rows.sort_by(&sort)
    end
  end

  def set(path, val)
    @options.update(path, val) ; end

  def interpret(string)
    eval(string) ; end

end

