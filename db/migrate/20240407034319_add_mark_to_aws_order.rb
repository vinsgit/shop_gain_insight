class AddMarkToAwsOrder < ActiveRecord::Migration[7.0]
  def change
    add_index :aws_orders, :posted_at
  end
end
