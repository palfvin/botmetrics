# use require to load any .js file available to the asset pipeline
#= require underscore
#= require pivot_table

describe "ChartScript", ->

  console.log('we made it to the ChartScript test')

  stringInputTable = [
    ["a", "r1", "c1"],
    ["b", "r1", "c2"],
    ["c", "r2", "c1"],
    ["d", "r2", "c2"]]

  isEqual = (obj1, obj2) ->
    JSON.stringify(obj1) == JSON.stringify(obj2)

  it "should match two objects", ->
    expect({a: "b", c: "d"}).toEqual({a: "b", c: "d"})

  it "should handle the church test case", ->
    conversion = "pivot({row: function(){return 'Rower'}, col: 0, val: 1})"
    table_dsl = new ChartScript([['Date', 'Attendance'], ['1/1/2013', 210], ['3/1/2013', 305]])
    table_dsl.interpret(conversion)
    expect(table_dsl.rows).toEqual([
      ['Attendance(Rower\\Date)', '1/1/2013', '3/1/2013'],
      ['Rower', 210, 305]])

  it "should do a basic pivot", ->
    conversion = "
      set('chart.type', 'column');
      set('title.text', 'Test Title');
      pivot({row: 1, col: 2, val: 0, aggregator: 'max', headers: null});"
    table_dsl = new ChartScript(stringInputTable)
    table_dsl.interpret(conversion)
    expect(table_dsl.rows).toEqual([
      ["", "c1", "c2"],
      ["r1", "a", "b"],
      ["r2", "c", "d"]])
    expect(isEqual(table_dsl.options,{
      chart: {type: 'column'},
      title: {text: 'Test Title'}})).toBeTruthy()

  it "should filter out rows", ->
    chart_script = new ChartScript([[0, "a"], [1, "b"]])
    chart_script.interpret("filter('row[0] > 0')")
    expect(chart_script.rows).toEqual([[1, "b"]])

  it "should sort rows with a header", ->
    table_header = ["Value", "Row", "Column"]
    chart_script = new ChartScript([table_header].concat(stringInputTable))
    chart_script.interpret("sort(2, true)")
    expect(chart_script.rows).toEqual([
      table_header,
      ["a", "r1", "c1"],
      ["c", "r2", "c1"],
      ["b", "r1", "c2"],
      ["d", "r2", "c2"]])
###