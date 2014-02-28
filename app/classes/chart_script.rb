require 'coffee-script'
require 'date_easter'

include ::NewRelic::Agent::MethodTracer


class ChartScript

  attr_reader :options, :data_sources

  def initialize(input_rows)
    @rows = input_rows
    @options = HashWithPathUpdate.new()
  end

  def unpivot
    pt = PivotTable.new(rows)
    self.rows = pt.unpivot
  end

  def pivot(aggregator, row, col, val, header = true)
    pt = PivotTable.new(rows)
    self.rows = pt.pivot(row: row, col: col, val: val, header: header, aggregator: aggregator)
  end

  def pivot2(pivot_options = {})
    pivot_options = js_object_to_hash_with_sym_keys(pivot_options) if pivot_options.class == V8::Object
    self.rows = PivotTable.new(rows).pivot(pivot_options)
  end

  def date(date_string)
    DateTime.parse(date_string, '%Y/%m/%d')
  rescue
    puts "Can't parse #{date_string}"
  end

  def pivot_js(options)
    hash = js_object_to_hash_with_sym_keys(options)
    pivot2(hash)
 end

  def js_object_to_hash_with_sym_keys(obj)
    obj.each_with_object({}) {|v, h| h[v[0].to_sym] = v[1]}
  end

  def filter2(filter_body)
    filter(filter_body)
  end

  def filter(predicate)
    (rows.length-1).downto(0) do |index|
      rows.delete_at(index) if !predicate.call(rows[index], index) # rescue false
    end
  end

  def reverse(header = true)
    self.rows = header ? [rows[0]]+rows[1..-1].reverse : rows.reverse
  end

  def sort(sort_index, header = true)
    sort = lambda {|row| row[sort_index]}
    if header
      self.rows = [rows[0]]+rows[1..-1].sort_by(&sort)
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
    string = "" if !string
    if string =~ /\A\/\//
      interpret_js(string)
    elsif string =~ /\A#/
      interpret_js(CoffeeScript::compile(string))
    else
      begin
        eval(string)
      rescue => exception
        trace = exception.backtrace
        last_stack_position = trace.index { |s| /^\(eval\):\d+:in `interpret'$/ =~ s } || 1
        puts "User error: #{exception.inspect}"
        puts "Backtrace: #{trace[1..last_stack_position]}"
        raise "Error in user code"
      end
    end
    self; end

  private

  SCRIPT_METHODS = [:puts]

  def self.convert_string_keys(hash)
    hash.keys.each do |key|
      if key.class == String
        case hash[key]
        when String, Fixnum, Array
          hash[key.to_sym] = hash.delete(key)
        else
          hash[key.to_sym] = self.convert_string_keys(hash[key])
          hash.delete(key)
        end
      end
    end
    hash
  end

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
    context['console'] = MyConsole.new
    context
  end

  JS_INIT = "
    botmetrics = {};
    botmetrics.cs = new ChartScript(rows);
    set = function (path, val) {botmetrics.cs.set(path, val)};
    pivot = function (options) {botmetrics.cs.pivot(options)};
    filter = function (filter_body) {botmetrics.cs.filter(filter_body)};
    sort = function (sort_index, header) {botmetrics.cs.sort(sort_index, header)};"

  class MyConsole
    def log(obj)
      puts obj.inspect
    end
  end

  def load_coffeescript_libraries(context)
    ['pivot_table'].each {|name| load_javascript(context, coffeescript_path(name))}
  end

  def load_javascript(context, path)
    javascript = /coffee$/ =~ path ? CoffeeScript::compile(File.read(path)) : File.read(path)
    context.eval(javascript)
  end

  def coffeescript_path(filename_root)
    path = Rails.root.join('app', 'assets', 'javascripts', "#{filename_root}.js.coffee").to_s
  end

  def load_libraries(context)
    load_coffeescript_libraries(context)
    load_javascript(context, Gem.loaded_specs['underscore-rails'].full_gem_path+'/vendor/assets/javascripts/underscore.js')
    context.eval(JS_INIT)
  end

  def set_variables_from_context(context)
    @rows = JSON[context.eval('JSON.stringify(botmetrics.cs.rows)')]
    @options = HashWithPathUpdate[self.class.convert_string_keys(JSON[context.eval('JSON.stringify(botmetrics.cs.options)')])]
  end

  def interpret_js(script)
    context = js_context
    load_libraries(context)
    context.eval(script)
    set_variables_from_context(context)
  end

  def rows=(value)
    @rows = value
  end

  [:pivot, :pivot2, :filter, :sort].each {|method| add_method_tracer(method)}

end

