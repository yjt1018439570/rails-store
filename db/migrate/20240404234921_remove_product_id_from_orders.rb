class RemoveProductIdFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :product_id, :integer
  end
end
