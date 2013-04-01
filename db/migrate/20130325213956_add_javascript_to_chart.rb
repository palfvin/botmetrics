class AddJavascriptToChart < ActiveRecord::Migration
  def change
    add_column :charts, :javascript, :text
  end
end
