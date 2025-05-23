class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.decimal :total_price
      t.integer :state
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
