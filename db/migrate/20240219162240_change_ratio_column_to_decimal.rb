class ChangeRatioColumnToDecimal < ActiveRecord::Migration[7.0]
  def change
    change_column :equity_allocation_records, :ratio, :decimal, precision: 1, scale: 2
  end
end
