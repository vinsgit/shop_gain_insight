class CreateDeliveries < ActiveRecord::Migration[7.0]
  def change
    create_table :deliverie_records do |t|
      t.date :deliver_at
      t.integer :sku_id
      t.integer :sent_count, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
