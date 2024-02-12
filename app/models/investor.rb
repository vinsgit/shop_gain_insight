# frozen_string_literal: true

class Investor < ApplicationRecord
  has_many :equity_allocation_records, dependent: :destroy
  accepts_nested_attributes_for :equity_allocation_records, allow_destroy: true
end
