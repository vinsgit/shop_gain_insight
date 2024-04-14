class AddAdsCostToSkus < ActiveRecord::Migration[7.0]
  def change
    add_column :skus, :ads_cost, :decimal, default: 0
  end
end
