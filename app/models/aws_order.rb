class AwsOrder < ApplicationRecord
  belongs_to :sku, optional: true
  belongs_to :shop

  validates :amt_type, presence: true, uniqueness: { scope: [:shop_id, :desc, :sku_id, :amt_type, :order_ref, :merchant_order_ref, :txn_type ] }

  def total_amt
    [amend_amt, amt, manual_amend_amt].sum
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
