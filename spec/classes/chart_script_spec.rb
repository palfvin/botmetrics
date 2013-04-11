require 'spec_helper'

describe ChartScript do

  let(:symbol_input_table) {[
      [:a, :r1, :c1],
      [:b, :r1, :c2],
      [:c, :r2, :c1],
      [:d, :r2, :c2]]}

  let(:numeric_input_table) {[
      [1, :r1, :c1],
      [2, :r1, :c2],
      [3, :r2, :c1]]}

  it "should handle a basic pivot DSL with :max" do
    conversion = "
      pivot :max, 1, 2, 0, false
      set 'chart.type', 'column'
      set 'title.text', 'Test Title'"
    table_dsl = ChartScript.new(symbol_input_table)
    table_dsl.interpret(conversion)
    table_dsl.rows.should == [
      [nil, :c1, :c2],
      [:r1, :a, :b],
      [:r2, :c, :d]]
    table_dsl.options.should == {
      chart: {type: 'column'},
      title: {text: 'Test Title'}
    }
  end

  it "should handle a basic pivot DSL with :average" do
    conversion = "
      pivot :average, 1, 2, 0, false
      set 'chart.type', 'column'
      set 'title.text', 'Test Title'"
    table_dsl = ChartScript.new(numeric_input_table*2)
    table_dsl.interpret(conversion)
    table_dsl.rows.should == [
      [nil, :c1, :c2],
      [:r1, 1, 2],
      [:r2, 3, nil]]
  end

  it "should filter out rows" do
    chart_script = ChartScript.new([[0, :a], [1, :b]])
    chart_script.interpret("filter 'row[0] > 0'")
    chart_script.rows.should == [[1, :b]]
  end

  it "should sort rows with a header" do
    table_header = [:Value, :Row, :Column]
    chart_script = ChartScript.new([table_header]+symbol_input_table)
    chart_script.sort(2, true)
    chart_script.rows.should == [
      table_header,
      [:a, :r1, :c1],
      [:c, :r2, :c1],
      [:b, :r1, :c2],
      [:d, :r2, :c2]]
  end

end