class RemoveFbmCostFromSkus < ActiveRecord::Migration[7.0]
  def change
    remove_column :skus, :fba_cost
    remove_column :skus, :fbm_cost
    remove_column :skus, :fba_ship_cost
    remove_column :skus, :fbm_ship_cost
    remove_column :skus, :extra_cost
  end
end
