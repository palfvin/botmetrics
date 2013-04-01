class PivotTable

  def initialize(table, options)
    @table = table
    @row_index = options[:row_index]
    @col_index = options[:col_index]
    @val_index = options[:val_index]
    @headers = options.has_key?(:headers) ? options[:headers] : true
    @row_headers = headers(@row_index)
    @col_headers = headers(@col_index)
  end

  def pivot(aggregator = :max)
    [[corner_label]+@col_headers]+@row_headers.collect do |row_val|
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

  def corner_label
    top_row[@row_index]+'\\'+top_row[@col_index] if @headers
  end

  def top_row ; @table[0] ; end

  def headers(index)
    cols(index).uniq
  end

  def data_rows
    puts "@headers = #{@headers}"
    @headers ? @table[1..-1] : @table
  end

  def cols(index)
    puts "data_rows = #{data_rows}"
    data_rows.collect {|row| row[index]}
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


