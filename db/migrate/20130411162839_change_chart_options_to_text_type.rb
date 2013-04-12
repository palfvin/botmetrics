class ChangeChartOptionsToTextType < ActiveRecord::Migration
  def self.up
    change_table :charts do |t|
      t.change :options, :text
    end
  end
  def self.down
    change_table :charts do |t|
      t.change :options, :string
    end
  end
end
