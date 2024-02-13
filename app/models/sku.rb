# frozen_string_literal: true

class Sku < ApplicationRecord
  has_and_belongs_to_many :item_links
  belongs_to :shop

  validates :name, presence: true, uniqueness: { scope: :shop_id }
end
