class AddCheckoutToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :checked_out, :boolean
    add_column :orders, :checked_out_at, :datetime
  end
end
