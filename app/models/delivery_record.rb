class DeliveryRecord < ApplicationRecord
  belongs_to :sku
  belongs_to :shop

  before_save :set_status_to_nil_after_count_matches

  validates :deliver_at, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['sku_name_cont']
  end

  def self.ransackable_associations(auth_object = nil)
    ['sku']
  end

  def stock_qty
    arrived_count - sent_count
  end

  private

  def set_status_to_nil_after_count_matches
    self.status = nil if sent_count == arrived_count && arrived_count != 0
  end
end
