class AddItemLinkIdToProcurements < ActiveRecord::Migration[7.0]
  def change
    add_column :procurements, :item_link_id, :integer
  end
end
