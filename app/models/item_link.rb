class ItemLink < ApplicationRecord
  has_and_belongs_to_many :skus
  belongs_to :shop

  validates :name, presence: true, uniqueness: { scope: :shop_id }
end
