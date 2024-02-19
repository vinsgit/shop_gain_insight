class CreateProcurements < ActiveRecord::Migration[7.0]
  def change
    create_table :procurements do |t|
      t.integer :sku_id
      t.integer :qty
      t.decimal :unit_price, precision: 8, scale: 2
      t.decimal :total_price, precision: 8, scale: 2
      t.integer :received_qty
      t.string :note

      t.timestamps
    end
  end
end
