class AddSettleIdToAwsOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :aws_orders, :settle_id, :string
  end
end
