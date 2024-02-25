# frozen_string_literal: true

module Sheet
module Sku
  class List < Base
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
      compose_content do |c|
        { sku: c[match_result[:sku]], price: c[match_result[:price]] }
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
