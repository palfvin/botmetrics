require 'spec_helper'

describe PivotTable do

  let(:pivoted_table) {[
      [nil, :c1, :c2],
      [:r1, :a, :b],
      [:r2, :c, :d]]}

  let(:unpivoted_table) {[
      [:r1, :c1, :a],
      [:r1, :c2, :b],
      [:r2, :c1, :c],
      [:r2, :c2, :d]]}

  let(:symbol_input_table) {[
      [:a, :r1, :c1],
      [:b, :r1, :c2],
      [:c, :r2, :c1],
      [:d, :r2, :c2]]}

  let(:numeric_input_table) {[
      [1, :r1, :c1],
      [2, :r1, :c2],
      [3, :r2, :c1]]}

  let(:header_input_row) {
      ['Value', 'Row', 'Column']}

  let(:corner_result) {'Value(Row\Column)'}
  let(:corner_result_lambda) {'ValueL(RowL\ColumnL)'}

  let(:header_options) { {row: 1, col: 2, val: 0}  }

  let(:header_options_with_lambdas) { {
    row: lambda {|r| r[1]},
    col: lambda {|r| r[2]},
    val: lambda {|r| r[0]},
    header: lambda { {row: 'RowL', col: 'ColumnL', val: 'ValueL'} }
    }}

  let(:headerless_options) { header_options.merge( { header: false} ) }

  def headerless_options_with(aggregator)
    headerless_options.merge({aggregator: aggregator})
  end

  it "should pivot a basic 2x3 table" do
    pt = PivotTable.new(symbol_input_table)
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, :a, :b],
      [:r2, :c, :d]]
    expect(pt.pivot(headerless_options)).to eq pivoted_table
  end

  it "should pivot a basic 2x3 table with a header" do
    pt = PivotTable.new([header_input_row]+symbol_input_table)
    pivoted_table = [
      [corner_result, :c1, :c2],
      [:r1, :a, :b],
      [:r2, :c, :d]]
    expect(pt.pivot(header_options)).to eq pivoted_table
  end

  it "should pivot a basic 2x3 table with a header and lambda functions" do
    pt = PivotTable.new([header_input_row]+symbol_input_table )
    pivoted_table = [
      [corner_result_lambda, :c1, :c2],
      [:r1, :a, :b],
      [:r2, :c, :d]]
    expect(pt.pivot(header_options_with_lambdas)).to eq pivoted_table
  end

  it "should pivot a table with count" do
    pt = PivotTable.new(symbol_input_table*2)
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 2, 2],
      [:r2, 2, 2]]
    expect(pt.pivot(headerless_options_with(:count))).to eq pivoted_table
  end

  it "should pivot a table with sum" do
    pt = PivotTable.new(numeric_input_table*2)
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 2, 4],
      [:r2, 6, nil]]
    expect(pt.pivot(headerless_options_with(:sum))).to eq pivoted_table
  end

  it "should pivot a table with average" do
    pt = PivotTable.new(numeric_input_table*2)
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 1, 2],
      [:r2, 3, nil]]
    expect(pt.pivot(headerless_options_with(:average))).to eq pivoted_table
  end

  it "should return nil for average of no data rather than generate, avoiding divide-by-zero error" do
    pt = PivotTable.new(numeric_input_table*2)
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 1, 2],
      [:r2, 3, nil]]
    expect(pt.pivot(headerless_options_with(:average))).to eq pivoted_table
  end

  it "should sort the column headers in reverse alphabetical order if I specify that" do
    column_sort = lambda {|obj|
      {c1: 2, c2: 1}[obj] }
    pt = PivotTable.new(symbol_input_table)
    pivoted_table = [
      [nil, :c2, :c1],
      [:r1, :b, :a],
      [:r2, :d, :c]]
    expect(pt.pivot(headerless_options.merge({col_sort_by: column_sort}))).to eq pivoted_table
  end

  it "should unpivot a table" do
    pt = PivotTable.new(pivoted_table)
    expect(pt.unpivot).to eq unpivoted_table
  end

  it "should pivot a table with a lambda count" do
    pt = PivotTable.new(symbol_input_table*2)
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 2, 2],
      [:r2, 2, 2]]
    expect(pt.pivot(headerless_options_with(-> (array) {array.count}))).to eq pivoted_table
  end

  it "should pivot a table with an array of aggregations" do
    pt = PivotTable.new(symbol_input_table*2)
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 6, 6],
      [:r2, 6, 6]]
    aggregator = ->(arr) {arr.inject(:+)}
    expect(pt.pivot(headerless_options_with([:count, :count, :count, aggregator]))).to eq pivoted_table
  end

  it "should pivot a table with an array of aggregations" do
    pt = PivotTable.new(symbol_input_table*2)
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 6, 6],
      [:r2, 6, 6]]
    aggregator = :sum
    expect(pt.pivot(headerless_options_with([:count, :count, :count, aggregator]))).to eq pivoted_table
  end

end
