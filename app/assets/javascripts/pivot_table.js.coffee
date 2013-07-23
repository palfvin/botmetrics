root = this

class HashWithPathUpdate

  constructor: (obj = {}) ->
    _.extend(this,obj)

  path_exists: (path) ->
    keys = path.split('.')
    h = @
    for key in keys
      if not h[key]?
        return false
      else
        h = h[key]
    return true

  update: (path, val, operation = 'replace') ->
    keys = path.split('.')
    h = @
    last_key = keys[keys.length-1]
    for key in keys.slice(0,-1)
      h[key] = {} if not h[key]
      h = h[key]
    if operation == 'append' and h[last_key]?
      h[last_key].push(val)
    else
      h[last_key] = val
    @

root.ChartScript = class ChartScript

  constructor: (@rows) ->
    @options = new HashWithPathUpdate

  interpret: (script) ->
    context = this
    preface = "
      function pivot(){context.pivot.apply(context,arguments)};
      function set(){context.set.apply(context,arguments)};
      function filter(){context.filter.apply(context,arguments)};
      function sort(){context.sort.apply(context,arguments)};"
    eval("(function (){#{preface}#{script}})()")

  set: (path, val) =>
    @options.update(path, val)

  pivot: (pivot_options) ->
    @rows = new PivotTable(@rows).pivot(pivot_options)

  filter: (filter) ->
    predicate = switch (typeof filter)
      when 'string' then eval("predicate = function (row, index) {return ( #{filter} )}")
      when 'function' then filter
      else raise 'Invalid filter'

    @rows = (@rows[i] for i in [0...@rows.length] when predicate.call(null, @rows[i], i))

  sort: (sort_index, header = true) ->
    sort_function = (a, b) ->
      v1 = a[sort_index]
      v2 = b[sort_index]
      return -1 if v1<v2
      return 1 if v1>v2
      return 0
    if header
      @rows = [@rows[0]].concat(@rows.slice(1).sort(sort_function))
    else
      @rows.sort(sort_function)

root.PivotTable = class PivotTable

  PIVOT_DEFAULTS: {row: 0, col: 1, val: 2, header: 0, aggregator: "max"}

  constructor: (@rows) ->
    @checkInputValidity()

  setUpHeaders: ->
    @rowHeaders = @pivotedHeaders(@options.row)
    @colHeaders = @pivotedHeaders(@options.col)
    @options.columnSort.call(null, @colHeaders) if @options.columnSort?
    @header_row = [@cornerLabel()].concat(@colHeaders)

  checkInputValidity: ->
    throw new Error('No rows provided') unless @rows

  pivot: (options = {}) ->
    @options = _.extend({},@PIVOT_DEFAULTS, options)
    @dataRows = @rows.slice(@firstDataRow())
    @setUpHeaders()
    [@header_row].concat(([rowVal].concat(@dataRow(rowVal)) for rowVal in @rowHeaders))

  firstDataRow: ->
    header = @options.header
    switch (typeof header)
      when 'object' then return 0   # includes case of header = null
      when 'number' then return header+1
      else raise 'Invalid header option'

  dataRow: (rowVal) ->
    (@aggregate(rowVal, colVal) for colVal in @colHeaders)

  aggregate: (rowVal, colVal) ->
    vals = []
    for row in @dataRows
       vals.push(@get(row, @options.val)) if @get(row, @options.row)==rowVal and @get(row,@options.col)==colVal
    this[@options.aggregator](vals) unless vals.length == 0

  cornerLabel: ->
    header = @options.header
    if header == null then return ""
    [row_name, col_name, val_name] = switch (typeof header)
      when "object" then [header.row, header.col, header.val]
      when "number" then [@get(@rows[header], @options.row), @get(@rows[header], @options.col), @get(@rows[header], @options.val)]
      else raise "Invalid header parameter"
    "#{val_name}(#{row_name}\\#{col_name})"

  pivotedHeaders: (index) ->
    _.unique(@cols(index)).sort()

  cols: (index) ->
    (@get(row,index) for row in @dataRows)

  max: (array) ->
    array.sort().slice(-1)[0]

  sum: (array) ->
    isNumber = @isNumber
    array.reduce (x, y) -> if isNumber(y) then x+y else x

  count: (array) ->
    array.length

  average: (array) ->
    Math.round(@sum(array)/@countOfNumbers(array))

  countOfNumbers: (array) ->
    isNumber = @isNumber
    array.reduce(((x, y) -> if isNumber(y) then x+1 else x), 0)

  isNumber: (v) ->
    (typeof v) == "number"

  get: (row, accessor) ->
    if @isNumber(accessor) then row[accessor] else accessor.call(null, row)


