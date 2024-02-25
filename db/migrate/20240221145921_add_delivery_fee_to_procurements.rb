class AddDeliveryFeeToProcurements < ActiveRecord::Migration[7.0]
  def change
    add_column :procurements, :delivery_fee, :decimal, default: 0
  end
end
