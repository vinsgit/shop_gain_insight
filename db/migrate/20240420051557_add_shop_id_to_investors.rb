class AddShopIdToInvestors < ActiveRecord::Migration[7.0]
  def change
    add_column :investors, :shop_id, :integer
  end
end
