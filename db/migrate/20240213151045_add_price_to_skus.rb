class AddPriceToSkus < ActiveRecord::Migration[7.0]
  def change
    add_column :skus, :price, :decimal, default: 0
  end
end
