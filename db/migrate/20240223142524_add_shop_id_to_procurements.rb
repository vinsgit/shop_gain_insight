class AddShopIdToProcurements < ActiveRecord::Migration[7.0]
  def change
    add_column :procurements, :shop_id, :integer
  end
end
