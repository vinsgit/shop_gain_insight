class CreateProcurementInvestors < ActiveRecord::Migration[7.0]
  def change
    create_table :procurement_investors do |t|
      t.integer :procurement_id
      t.integer :investor_id
      t.decimal :ratio, precision: 1, scale: 2

      t.timestamps
    end
  end
end
