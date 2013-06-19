require 'spec_helper'

describe ChartScript do

  SYMBOL_INPUT = [
      [:a, :r1, :c1],
      [:b, :r1, :c2],
      [:c, :r2, :c1],
      [:d, :r2, :c2]];

  let(:symbol_input_table) {[
      [:a, :r1, :c1],
      [:b, :r1, :c2],
      [:c, :r2, :c1],
      [:d, :r2, :c2]]}

  let(:numeric_input_table) {[
      [1, :r1, :c1],
      [2, :r1, :c2],
      [3, :r2, :c1]]}

  def convert_to_strings(array)
    array.collect do |v|
      case v
        when Array
          convert_to_strings(v)
        when Symbol, NilClass
          v.to_s
        else v
      end
    end
  end

  it "should handle the church test case" do
    conversion = "pivot2(row: lambda {|r| 'Rower'}, col: 0, val: 1)"
    table_dsl = ChartScript.new([['Date', 'Attendance'], ['1/1/2013', 210], ['3/1/2013', 305]])
    table_dsl.interpret(conversion)
    table_dsl.rows.should == [
      ['Attendance(Rower\Date)', '1/1/2013', '3/1/2013'],
      ['Rower', 210, 305]]
  end

 it "should be able to process basic javascript arrays" do
    conversion = "// Header for javascript
      "
    table_dsl = ChartScript.new([[1,2]])
    table_dsl.interpret(conversion)
    table_dsl.rows.should == [
      [1,2]]
  end

 it "should be able to process javascript" do
    conversion = "// Header for javascript
      set('chart.type', 'column');
      set('title.text', 'Test Title');
      pivot({row: 1, col: 2, val: 0, aggregator: 'max', headers: null});
      "
    table_dsl = ChartScript.new(symbol_input_table)
    table_dsl.interpret(conversion)
    table_dsl.rows.should == convert_to_strings([
      [nil, :c1, :c2],
      [:r1, :a, :b],
      [:r2, :c, :d]])
    table_dsl.options.should == {
      chart: {type: 'column'},
      title: {text: 'Test Title'}
    }
  end

  it "should be able to process coffeescript" do
    conversion = "#
      "
    table_dsl = ChartScript.new([[1,2]])
    table_dsl.interpret(conversion)
    table_dsl.rows.should == [
      [1,2]]
  end

  it "should be able to process javascript a second time" do
    conversion = "# Header for coffeescript
      set('chart.type', 'column')
      set('title.text', 'Test Title')
      pivot({row: 1, col: 2, val: 0, aggregator: 'max', headers: null})
      "
      table_dsl = ChartScript.new(symbol_input_table)
      table_dsl.interpret(conversion)
      table_dsl.rows.should == convert_to_strings([
        [nil, :c1, :c2],
        [:r1, :a, :b],
        [:r2, :c, :d]])
      table_dsl.options.should == {
        chart: {type: 'column'},
        title: {text: 'Test Title'}
      }
  end

  it "should be able to process javascript a second time" do
    conversion = "// Header for javascript
      set('chart.type', 'column');
      set('title.text', 'Test Title');
      pivot({row: 1, col: 2, val: 0, aggregator: 'max', headers: null});
      "
      table_dsl = ChartScript.new(symbol_input_table)
      table_dsl.interpret(conversion)
      table_dsl.rows.should == convert_to_strings([
        [nil, :c1, :c2],
        [:r1, :a, :b],
        [:r2, :c, :d]])
      table_dsl.options.should == {
        chart: {type: 'column'},
        title: {text: 'Test Title'}
      }
  end

  it "should handle a basic pivot DSL with :max" do
    conversion = "
      pivot2(row: 1, col: 2, val: 0, headers: false)
      set('chart.type', 'column')
      set('title.text', 'Test Title')"
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
      pivot2(aggregator: :average, row: 1, col: 2, val: 0, headers: false)
      set('chart.type', 'column')
      set('title.text', 'Test Title')"
    table_dsl = ChartScript.new(numeric_input_table*2)
    table_dsl.interpret(conversion)
    table_dsl.rows.should == [
      [nil, :c1, :c2],
      [:r1, 1, 2],
      [:r2, 3, nil]]
  end

  it "should filter out rows" do
    chart_script = ChartScript.new([[0, :a], [1, :b]])
    chart_script.interpret("//\nfilter('row[0] > 0')")
    chart_script.rows.should == convert_to_strings([[1, :b]])
  end

  it "should sort rows with a header" do
    table_header = [:Value, :Row, :Column]
    chart_script = ChartScript.new([table_header]+symbol_input_table)
    chart_script.interpret("//\nsort(2, true)")
    chart_script.rows.should == convert_to_strings([
      table_header,
      [:a, :r1, :c1],
      [:c, :r2, :c1],
      [:b, :r1, :c2],
      [:d, :r2, :c2]])
  end

end