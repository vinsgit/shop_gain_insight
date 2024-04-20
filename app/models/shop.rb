# frozen_string_literal: true

class Shop < ApplicationRecord
  validates :name, presence: true

  has_many :investors
  has_many :aws_orders
  has_many :delivery_records
  has_many :fbm_delivery_records
  has_many :item_links
  has_many :procurements
  has_many :shipments
  has_many :skus

end
