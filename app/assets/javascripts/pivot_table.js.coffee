Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

root = exports ? this

root.Botmetrics or= {}

class Hash
  constructor: (@obj) ->

  merge: (obj) ->
    result = {}
    for attrname of obj
      result[attrname] = obj[attrname]
    for attrname of @obj
      result[attrname] = @obj[attrname] unless attrname of result
    return result

root.Botmetrics.PivotTable = class PivotTable

  PIVOT_DEFAULTS: new Hash({row: 0, col: 1, val: 2, first_data_row: 0, headers: false, aggregator: "max"})

  constructor: (@rows) ->
    @check_input_validity()
    console.log("Rows at constructor")
    console.log(@rows)

  set_up_headers: ->
    @row_headers = @pivoted_headers(@options.row)
    @col_headers = @pivoted_headers(@options.col)
#    @col_headers.sort_by! &@options[:col_sort_by] if @options[:col_sort_by]
    @header_row = [@corner_label()].concat(@col_headers)

  check_input_validity: ->
    throw new Error('No rows provided') unless @rows

  pivot: (options = {}) ->
    @options = @PIVOT_DEFAULTS.merge(options)
    @data_rows = @rows.slice(@options.first_data_row)
    @set_up_headers()
    console.log("Header row in brackets is #{[[@header_row]]}")
    [@header_row].concat(([row_val].concat(@data_row(row_val)) for row_val in @row_headers))

  data_row: (row_val) ->
    (@aggregate(row_val, col_val) for col_val in @col_headers)

  aggregate: (row_val, col_val) ->
    vals = []
    for row in @data_rows
       vals.push(@get(row, @options.val)) if @get(row, @options.row)==row_val and @get(row,@options.col)==col_val
    this[@options.aggregator](vals) unless vals.length == 0

  corner_label: ->
    headers = @options.headers
    return "" if !headers
    [row_name, col_name, val_name] = switch (typeof headers)
      when "object" then [headers.row, headers.col, headers.val]
      when "number" then [get(@rows[header], @options.row), get(@rows[header], @options.col), get(@rows[header], @options.val)]
      else throw "Invalid header paramter"
    "#{val_header}(#{row_header}\\#{col_header})"

  top_row: ->
    @rows[0]

  pivoted_headers: (index) ->
    @cols(index).unique().sort()

  cols: (index) ->
    (@get(row,index) for row in @data_rows)

  max: (array) ->
    array.sort().slice(-1)[0]

  sum: (array) ->
    array.reduce (x, y) -> if @is_number(y) then x+y else x

  count: (array) ->
    array.length

  average: (array) ->
    (sum(array)/count_of_numbers(array)).round(2) rescue nil

  count_of_numbers: (array) ->
    array.reduce (x, y) -> if is_number?(v) then x+1 else x

  is_number: (v) ->
    (typeof v) == "number"

  get: (row, accessor) ->
    if @is_number(accessor) then row[accessor] else accessor(row)

root.pivot = (options = {}) =>
  console.log("Before value is #{JSON.stringify(rows)}")
  root.rows = new root.Botmetrics.PivotTable(rows).pivot(options)
  console.log("After value is #{JSON.stringify(rows)}")


