class AddShopIdToDeliveryRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :delivery_records, :shop_id, :integer
  end
end
