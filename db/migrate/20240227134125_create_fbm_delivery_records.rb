class CreateFbmDeliveryRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :fbm_delivery_records do |t|
      t.integer :shop_id
      t.integer :sku_id
      t.date :purchased_at
      t.decimal :amt
      t.string :note
      t.string :purchase_note
      t.string :delivery_method
      t.string :delivery_status
      t.string :order_note
      t.string :aws_order_ref

      t.timestamps
    end
  end
end
