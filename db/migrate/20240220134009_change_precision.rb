class ChangePrecision < ActiveRecord::Migration[7.0]
  def change
    change_column :equity_allocation_records, :ratio, :decimal
    change_column :procurement_investors, :ratio, :decimal
  end
end
