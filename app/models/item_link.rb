class ItemLink < ApplicationRecord
  has_and_belongs_to_many :skus
end
