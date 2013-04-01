class PivotTable

  def initialize(table, row_index, col_index, val_index)
    @table = table
    @row_index = row_index
    @col_index = col_index
    @val_index = val_index
    @row_headers = headers(row_index)
    @col_headers = headers(col_index)
  end

  def pivot(aggregator = :max)
    [[nil]+@col_headers]+@row_headers.collect do |row_val|
      [row_val] + @col_headers.collect do |col_val|
        aggregate(row_val, col_val, aggregator)
      end
    end
  end

  def aggregate(row_val, col_val, aggregator)
    vals = []
    @table.each {|row|
      vals << row[@val_index] if row[@row_index]==row_val and row[@col_index]==col_val}
    self.send(aggregator, vals)
  end

  def headers(index)
    cols(index).uniq
  end

  def cols(index)
    @table.collect {|row| row[index]}
  end

  def max(array)
    array.max
  end

  def sum(array)
    array.inject(0,:+)
  end

  def count(array)
    array.length
  end

  def average(array)
    sum(array)/count(array)
  end

end


