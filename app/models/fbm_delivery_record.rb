class FbmDeliveryRecord < ApplicationRecord
  belongs_to :sku
  belongs_to :shop

  validates :purchased_at, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['sku_name_cont']
  end

  def self.ransackable_associations(auth_object = nil)
    ['sku']
  end

end
