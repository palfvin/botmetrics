class PivotTable

  PIVOT_DEFAULTS = {row: 0, col: 1, val: 2, header: true, aggregator: :max}

  def initialize(rows)
    @table = rows
    check_input_validity
  end

  def set_up_headers
    @header = @options[:header]
    @row_headers = header(row_accessor)
    @row_headers.sort_by! &@options[:row_sort_by] if @options[:row_sort_by]
    @col_headers = header(col_accessor)
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
    raise unless @table.class==Array
  end

  def pivot(options)
    @options = PIVOT_DEFAULTS.merge(options)
    set_up_headers
    header_row+@row_headers.collect {|row_val| data_row(row_val)}
  end

  def header_row
    [[corner_label]+@col_headers]
  end

  def data_row(row_val)
    [row_val] + @col_headers.collect do |col_val|
      aggregate(row_val, col_val)
    end
  end

  def aggregate(row_val, col_val)
    vals = []
    data_rows.each {|row|
      vals << get(row, val_accessor) if get(row, row_accessor)==row_val and get(row,col_accessor)==col_val}
    self.send(@options[:aggregator].to_sym, vals) unless vals.length == 0
  end

  def corner_label
    return nil if !@header
    if @header.is_a?(Proc)
      row_header, col_header, val_header = @header.call[:row], @header.call[:col], @header.call[:val]
    elsif @header.is_a?(Hash)
      row_header, col_header, val_header = @header[:row], @header[:col], @header[:val]
    else
      row_header, col_header, val_header = get(top_row, row_accessor), get(top_row, col_accessor), get(top_row, val_accessor)
    end
    "#{val_header}(#{row_header}\\#{col_header})"
  end

  def top_row ; @table[0] ; end

  def header(index)
    cols(index).uniq.sort
  end

  def data_rows
    @header ? @table[1..-1] : @table
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


