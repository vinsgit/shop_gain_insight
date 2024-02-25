class AddPurchasedAtToProcurements < ActiveRecord::Migration[7.0]
  def change
    add_column :procurements, :purchased_at, :date
  end
end
