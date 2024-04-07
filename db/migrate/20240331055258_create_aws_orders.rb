class CreateAwsOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :aws_orders do |t|
      t.string :order_ref
      t.string :merchant_order_ref
      t.string :desc
      t.decimal :amt, default: 0
      t.integer :sku_id
      t.string :promotion_ref
      t.decimal :amend_amt, default: 0
      t.decimal :manual_amend_amt, default: 0
      t.string :note
      t.timestamps
    end
  end
end
