class CreateJoinTableItemLinksSkus < ActiveRecord::Migration[7.0]
  def change
    create_join_table :skus, :item_links do |t|
      t.index [:sku_id, :item_link_id]
      t.index [:item_link_id, :sku_id]
    end
  end
end
