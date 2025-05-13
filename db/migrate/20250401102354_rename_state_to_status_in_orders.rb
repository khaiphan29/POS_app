class RenameStateToStatusInOrders < ActiveRecord::Migration[7.2]
  def change
    rename_column :orders, :state, :status
  end
end
