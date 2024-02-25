class Procurement < ApplicationRecord
  has_many :procurement_investors, dependent: :destroy
  has_many :investors, through: :procurement_investors
  belongs_to :sku
  belongs_to :item_link
  belongs_to :shop

  def self.ransackable_attributes(auth_object = nil)
    ['sku_name_cont']
  end

  def self.ransackable_associations(auth_object = nil)
    ['sku']
  end
end
