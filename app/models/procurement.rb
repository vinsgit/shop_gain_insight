class Procurement < ApplicationRecord
  has_many :procurement_investors, dependent: :destroy
  has_many :investors, through: :procurement_investors
end
