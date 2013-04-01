describe PivotTable do

  let(:symbol_input_table) {[
      [:a, :r1, :c1],
      [:b, :r1, :c2],
      [:c, :r2, :c1],
      [:d, :r2, :c2]]}

  let(:numeric_input_table) {[
      [1, :r1, :c1],
      [2, :r1, :c2],
      [3, :r2, :c1],
      [4, :r2, :c2]]}

  it "should pivot a basic 2x3 table" do
    pt = PivotTable.new(symbol_input_table, 1, 2, 0)
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, :a, :b],
      [:r2, :c, :d]]
    pt.pivot().should == pivoted_table
  end

  it "should pivot a table with count" do
    pt = PivotTable.new(symbol_input_table*2, 1, 2, 0)
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 2, 2],
      [:r2, 2, 2]]
    pt.pivot(:sum).should == pivoted_table
  end

  it "should pivot a table with average" do
    pt = PivotTable.new(numeric_input_table*2, 1, 2, 0)
    pivoted_table = [
      [nil, :c1, :c2],
      [:r1, 2, 4],
      [:r2, 6, 8]]
    pt.pivot(:sum).should == pivoted_table
  end

end
