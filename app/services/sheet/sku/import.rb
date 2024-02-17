# frozen_string_literal: true

module Sheet
module Sku
  class Import < Base
    def import!(shop_id)
      return false unless key_fields_not_existed?

      attributes.each do |att|
        r = ::Sku.find_or_initialize_by(name: att[:sku], shop_id: shop_id)
        r.price = att[:price]
        r.save
      end

      return true
    end

    private

    def attributes
      sku_index = match_result[:sku]
      price_index = match_result[:price]

      compose_content do |c|
        { sku: c[sku_index], price: c[price_index] }
      end
    end

    def match_fields
      { sku: 'sku', price: 'your-price' }
    end

    def first_row
      super
    end

    def last_row
      super
    end

    def header
      super
    end
  end
end
end
