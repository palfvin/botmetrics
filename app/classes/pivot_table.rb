class PivotTable

  def initialize(rows, options)
    @table = rows
    @options = options
    check_input_validity
    set_up_headers
  end

  def set_up_headers
    @headers = @options.has_key?(:headers) ? @options[:headers] : true
    @row_headers = headers(row_accessor)
    @col_headers = headers(col_accessor)
    @col_headers.sort_by! &@options[:col_sort_by] if @options[:col_sort_by]
  end

  def row_accessor
    @options[:row]
  end

  def col_accessor
    @options[:col]
  end

  def val_accessor
    @options[:val]
  end

  def check_input_validity
    raise unless @table
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
    data_rows.each {|row|
      vals << get(row, val_accessor) if get(row, row_accessor)==row_val and get(row,col_accessor)==col_val}
    self.send(aggregator, vals) unless vals.length == 0
  end

  def corner_label
    return nil if !@headers
    if @headers.is_a?(Proc)
      row_header, col_header, val_header = @headers.call[:row], @headers.call[:col], @headers.call[:val]
    else
      row_header, col_header, val_header = get(top_row, row_accessor), get(top_row, col_accessor), get(top_row, val_accessor)
    end
    "#{val_header}(#{row_header}\\#{col_header})"
  end

  def top_row ; @table[0] ; end

  def headers(index)
    cols(index).uniq.sort
  end

  def data_rows
    @headers ? @table[1..-1] : @table
  end

  def cols(index)
    data_rows.collect {|row| get(row,index)}
  end

  def max(array)
    array.max
  end

  def sum(array)
    array.inject(0) {|memo, obj| is_number?(obj) ? memo+obj : memo}
  end

  def count(array)
    array.length
  end

  def average(array)
    (sum(array)/count_of_numbers(array)).round(2) rescue nil ; end

  def count_of_numbers(array)
    array.count {|v| is_number?(v)}
  end

  def is_number?(v)
    true if Float(v) rescue false
  end

  def get(row, accessor)
    accessor.is_a?(Integer) ? row[accessor] : accessor.call(row)
  end

end


