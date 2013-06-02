require 'coffee-script'

class ChartScript

  attr_reader :options, :data_sources

  def initialize(input_rows)
    puts "#{self.inspect} created at #{Time.now}"
    @rows = input_rows
    @options = HashWithPathUpdate.new()
  end

  def pivot(aggregator, row, col, val, headers = true)
    self.rows = PivotTable.new(rows).pivot(rows, row: row, col: col, val: val, headers: headers, aggregator: aggregator)
  end

  def pivot2(pivot_options = {})
    pivot_options = js_object_to_hash_with_sym_keys(pivot_options) if pivot_options.class == V8::Object
    self.rows = PivotTable.new(rows).pivot(pivot_options)
  end

  def pivot_js(options)
    hash = js_object_to_hash_with_sym_keys(options)
    pivot2(hash)
 end

  def js_object_to_hash_with_sym_keys(obj)
    obj.each_with_object({}) {|v, h| h[v[0].to_sym] = v[1]}
  end

  def filter(filter_body)
    predicate = eval("lambda {|row, index| #{filter_body} }")
    (rows.length-1).downto(0) do |index|
      rows.delete_at(index) if !predicate.call(rows[index], index) rescue false
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

  def pivot3(obj) ; pivot2(obj) ; end

  def rows
    @rows
  end

  def set(path, val)
    @options.update(path, val) ; end

  def interpret(string)
    if string =~ /\A\/\//
      interpret_js(string)
    else
      eval(string)
    end; end

  private

  SCRIPT_METHODS = [:set, :puts]

  def js_context
    context = V8::Context.new
    SCRIPT_METHODS.each do |js_method|
      case js_method
        when Symbol
          context[js_method.to_s] = method(js_method)
        when Array
          context[js_method[1].to_s] = method(js_method[0])
      end
    end
    context['rows'] = @rows
    context
  end

  class MyConsole
    def log(obj)
      puts [[1,2]].inspect
      puts obj.inspect
    end
  end

  def interpret_js(script)
    preface = File.read('/Users/palfvin/tmp/pivot_table.js.js')
    context = js_context
    context['console'] = MyConsole.new
    context['rows'] = @rows
    @rows = context.eval(preface+script)
    puts "Rows context is #{context['rows']}"
  end

  def rows=(value)
    @rows = value
  end

end

