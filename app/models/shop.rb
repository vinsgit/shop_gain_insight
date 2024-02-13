# frozen_string_literal: true

class Shop < ApplicationRecord
  validates :name, presence: true
end
