class AddPostedDateToAwsOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :aws_orders, :posted_at, :date
  end
end
