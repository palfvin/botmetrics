class ChangeOwnerToUserInDashboards < ActiveRecord::Migration
  def up
    rename_column :dashboards, :owner_id, :user_id
  end

  def down
  end
end
