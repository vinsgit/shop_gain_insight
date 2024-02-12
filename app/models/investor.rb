# frozen_string_literal: true

class Investor < ApplicationRecord
  has_many :equity_allocation_records, dependent: :destroy

  def save_allocation(ratio:, start_at:, end_at:)
    equity_allocation_records.create(ratio: ratio, start_at: start_at, end_at: end_at)
  end
end
