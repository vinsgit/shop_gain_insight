class AddStatusToDeliveryRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :delivery_records, :status, :string
  end
end
