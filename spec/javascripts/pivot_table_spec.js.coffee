# use require to load any .js file available to the asset pipeline
#= require underscore
#= require pivot_table


describe "PivotTable", ->

  expectedCorner = 'Value(Row\\Column)'

  pivotedTable = (values, corner = "") ->
    table = [
      [corner, "c1", "c2"],
      ["r1", null, null],
      ["r2", null, null]]
    [table[1][1..2], table[2][1..2]] = values
    table

  defaultPivotedTable = (corner = "") ->
    defaultPivotedValues = [["a", "b"], ["c", "d"]]
    pivotedTable(defaultPivotedValues, corner)

  duplicate = (array) ->
    array.concat(array)

  merge = (obj1, obj2) ->
    _.extend({}, obj1, obj2)

  [stringInputTable, headerOptions, headerlessOptions, defaultPivotedValues] = []

  beforeEach ->

    stringInputTable = [
      ["a", "r1", "c1"],
      ["b", "r1", "c2"],
      ["c", "r2", "c1"],
      ["d", "r2", "c2"]]

    headerOptions = {row: 1, col: 2, val: 0}
    headerlessOptions = merge(headerOptions, { header: null} )

  it "should pivot a basic 2x3 table without header", ->
    pt = new PivotTable(stringInputTable)
    expect(pt.pivot(headerlessOptions)).toEqual(defaultPivotedTable())

  it "should pivot a basic 2x3 table with a header", ->
    headerInputRow = ['Value', 'Row', 'Column']
    pt = new PivotTable([headerInputRow].concat(stringInputTable))
    expect(pt.pivot(headerOptions)).toEqual(defaultPivotedTable(expectedCorner))

  it "should pivot a basic 2x3 table with functions for row/col/val and an object for header", ->
    complexOptions = {
      row: (r) -> r[headerOptions.row]
      col: (r) -> r[headerOptions.col]
      val: (r) -> r[headerOptions.val]
      header: {row: 'Row', col: 'Column', val: 'Value'}
      }
    pt = new PivotTable(stringInputTable)
    expect(pt.pivot(complexOptions)).toEqual(defaultPivotedTable(expectedCorner))

  it "should sort the column header in reverse alphabetical order if I specify that", ->
    columnSort = (array) ->
      array.sort().reverse()
    pt = new PivotTable(stringInputTable)
    reverseSortedPivotedTable = [
      ["", "c2", "c1"],
      ["r1", "b", "a"],
      ["r2", "d", "c"]]
    expect(pt.pivot(merge(headerlessOptions, {columnSort: columnSort}))).toEqual(reverseSortedPivotedTable)

  describe 'aggregation support', ->

    headerlessOptionsWith = (aggregator) ->
      merge(headerlessOptions, {aggregator: aggregator})

    numericInputTable = [
      [1, "r1", "c1"],
      [2, "r1", "c2"],
      [3, "r2", "c1"]]

    pt = null

    beforeEach ->
      pt = new PivotTable(duplicate(numericInputTable))

    it "should pivot a table with count", ->
      expect(pt.pivot(headerlessOptionsWith("count"))).toEqual(pivotedTable([[2, 2],[2, undefined]]))

    it "should pivot a table with sum", ->
      expect(pt.pivot(headerlessOptionsWith("sum"))).toEqual(pivotedTable([[2, 4], [6, undefined]]))

    it "should pivot a table with average", ->
      expect(pt.pivot(headerlessOptionsWith("average"))).toEqual(pivotedTable([[1, 2],[3, undefined]]))


