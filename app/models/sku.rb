# frozen_string_literal: true

class Sku < ApplicationRecord
  has_and_belongs_to_many :item_links
  belongs_to :shop

  validates :name, presence: true, uniqueness: { scope: :shop_id }

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
