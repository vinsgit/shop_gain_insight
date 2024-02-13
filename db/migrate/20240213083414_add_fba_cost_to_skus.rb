class AddFbaCostToSkus < ActiveRecord::Migration[7.0]
  def change
    add_column :skus, :fba_cost, :decimal, default: 0
    add_column :skus, :fbm_cost, :decimal, default: 0
    add_column :skus, :fba_ship_cost, :decimal, default: 0
    add_column :skus, :fbm_ship_cost, :decimal, default: 0
    add_column :skus, :extra_cost, :decimal, default: 0
    add_column :skus, :note, :string
  end
end
