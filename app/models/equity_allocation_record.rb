
# frozen_string_literal: true

class EquityAllocationRecord < ApplicationRecord
  belongs_to :investor

  validates :ratio, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1,
    message: "必须介于0和1之间"
  }
end
