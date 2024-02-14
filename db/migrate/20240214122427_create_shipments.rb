class CreateShipments < ActiveRecord::Migration[7.0]
  def change
    create_table :shipments do |t|
      t.datetime :transaction_at
      t.string :aws_order_ref
      t.string :order_ref
      t.decimal :total_fee, default: 0
      t.integer :channel

      t.timestamps
    end
  end
end
