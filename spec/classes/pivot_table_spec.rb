require 'spec_helper'

describe PivotTable do

  let(:symbol_input_table) {[
      [:a, :r1, :c1],
      [:b, :r1, :c2],
      [:c, :r2, :c1],
      [:d, :r2, :c2]]}

  let(:numeric_input_table) {[
      [1, :r1, :c1],
      [2, :r1, :c2],
      [3, :r2, :c1]]}

  let(:header_options) { {row_index: 1, col_index: 2, val_index: 0}  }

  let(:headerless_options) { header_options.merge( { headers: false} ) }

  it "should pivot a basic 2x3 table" do
    pt = PivotTable.new(symbol_input_table, headerless_options )
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, :a, :b],
      [:r2, :c, :d]]
    pt.pivot().should == pivoted_table
  end

  it "should pivot a table with count" do
    pt = PivotTable.new(symbol_input_table*2, headerless_options )
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 2, 2],
      [:r2, 2, 2]]
    pt.pivot(:count).should == pivoted_table
  end

  it "should pivot a table with sum" do
    pt = PivotTable.new(numeric_input_table*2, headerless_options )
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 2, 4],
      [:r2, 6, nil]]
    pt.pivot(:sum).should == pivoted_table
  end

  it "should pivot a table with average" do
    pt = PivotTable.new(numeric_input_table*2, headerless_options )
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 1, 2],
      [:r2, 3, nil]]
    pt.pivot(:average).should == pivoted_table
  end

  it "should return nil for average of no data rather than generate, avoiding divide-by-zero error" do
    pt = PivotTable.new(numeric_input_table*2, headerless_options )
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 1, 2],
      [:r2, 3, nil]]
    pt.pivot(:average).should == pivoted_table
  end

end
