# frozen_string_literal: true

class Investor < ApplicationRecord
  belongs_to :shop
  has_many :equity_allocation_records, dependent: :destroy
  accepts_nested_attributes_for :equity_allocation_records, allow_destroy: true

  def current_equity_allocation_record
    equity_allocation_records.last
  end
end
