class CreateSkus < ActiveRecord::Migration[7.0]
  def change
    create_table :skus do |t|
      t.string :name

      t.timestamps
    end
  end
end
