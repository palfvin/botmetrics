require 'spec_helper'

describe Table do

  let(:user) { FactoryGirl.create(:user) }
  let(:table) {user.tables.create()}

  subject { table }

  it { should respond_to(:data_source) }
  it { should respond_to(:data) }
  it { should respond_to(:name) }
  it { should respond_to(:user_id) }

  describe "when user_id is not present" do
    before { table.user_id = nil }
    it { should_not be_valid}
  end

  # describe "acessible attributes" do
  #   it "should not allow access to user_id" do
  #     expect do
  #       Table.new(user_id: user.id)
  #     end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #   end
  # end

  it "should serialize data submitted" do
    table = user.tables.create(data: base_data_sample[:data])
    expect(table.data).to eq(base_data_sample[:data])
  end

  it "should pull data from another table" do
    table1 = user.tables.create(data: base_data_sample[:data])
    table2 = user.tables.create(data_source: "Table(#{table1.id})")
    table2.refresh
    expect(table2.data).to eq(base_data_sample[:data])
  end

  it "should refresh data on request" do
    table1 = user.tables.create(data: base_data_sample[:data])
    table2 = user.tables.create(data_source: "Table(#{table1.id})", data: "otherdata")
    expect(table2.data).to eq("otherdata")
    table2.refresh
    expect(table2.data).to eq(base_data_sample[:data])
  end

  context "with dependent charts" do
    let!(:chart1) {user.charts.create(table_id: table.id)}
    let!(:chart2) {user.charts.create(table_id: table.id)}
    it "should refresh charts when table is updated" do
      table.reload
      table.data = base_data_sample[:data]
      before_save_time = Time.now
      table.save
      [chart1, chart2].each do |chart|
        chart.reload
        expect(chart.updated_at).to be > before_save_time
      end
    end
  end

end