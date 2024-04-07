class AddTransactionTypeToAwsOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :aws_orders, :txn_type, :string
    add_column :aws_orders, :amt_type, :string
  end
end
