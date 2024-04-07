class AddShopIdToAwsOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :aws_orders, :shop_id, :integer
  end
end
