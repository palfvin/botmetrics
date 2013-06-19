require 'coffee-script'
require 'date_easter'

class ChartScript

  attr_reader :options, :data_sources

  def initialize(input_rows)
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
    elsif string =~ /\A#/
      interpret_js(CoffeeScript::compile(string))
    else
      eval(string)
    end; end

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
    context
  end

  JS_INIT = "
    botmetrics.cs = new botmetrics.ChartScript(rows);
    set = function (path, val) {botmetrics.cs.set(path, val)};
    pivot = function (options) {botmetrics.cs.pivot(options)};
    filter = function (filter_body) {botmetrics.cs.filter(filter_body)};
    sort = function (sort_index, headers) {botmetrics.cs.sort(sort_index, headers)};"

  class MyConsole
    def log(obj)
      puts obj.inspect
    end
  end

  def interpret_js(script)
    preface = File.read('/Users/palfvin/tmp/pivot_table.js.js')
    underscore = File.read('/Users/palfvin/.rvm/gems/ruby-1.9.3-p194@rails3tutorial2ndEd/gems/underscore-rails-1.4.4/vendor/assets/javascripts/underscore.js')
    context = js_context
    context['console'] = MyConsole.new
    context['rows'] = @rows
    context.eval("botmetrics = {};\n"+underscore+preface+JS_INIT)
    context.eval(script)
    @rows = JSON[context.eval('JSON.stringify(botmetrics.cs.rows)')]
    @options = HashWithPathUpdate[self.class.convert_string_keys(JSON[context.eval('JSON.stringify(botmetrics.cs.options)')])]
  end

  def rows=(value)
    @rows = value
  end

end

