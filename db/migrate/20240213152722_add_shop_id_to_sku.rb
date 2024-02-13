class AddShopIdToSku < ActiveRecord::Migration[7.0]
  def change
    add_column :skus, :shop_id, :integer
    add_column :item_links, :shop_id, :integer
  end
end
