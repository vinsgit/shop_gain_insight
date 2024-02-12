class CreateEquityAllocationRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :equity_allocation_records do |t|
      t.integer :investor_id
      t.integer :ratio, default: 0
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
