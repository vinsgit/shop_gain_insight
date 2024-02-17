# frozen_string_literal: true

module Sheet
module Sku
  class Import < Base
    FIELDS = [
      "sku",
      "fnsku",
      "asin",
      "product-name",
      "condition",
      "your-price",
      "mfn-listing-exists",
      "mfn-fulfillable-quantity",
      "afn-listing-exists",
      "afn-warehouse-quantity",
      "afn-fulfillable-quantity",
      "afn-unsellable-quantity",
      "afn-reserved-quantity",
      "afn-total-quantity",
      "per-unit-volume",
      "afn-inbound-working-quantity",
      "afn-inbound-shipped-quantity",
      "afn-inbound-receiving-quantity",
      "afn-researching-quantity",
      "afn-reserved-future-supply",
      "afn-future-supply-buyable"
    ]

    def perform!(shop_id)
      return false unless key_fields_not_misplaced?

      attributes.each do |att|
        r = ::Sku.find_or_initialize_by(name: att[:sku], shop_id: shop_id)
        r.price = att[:price]
        r.save
      end

      return true
    end

    private

    def attributes
      content do |arr|
        { sku: arr[0], price: arr[5] }
      end
    end

    def fields
      row(1)
    end

    def key_fields_not_misplaced?
      FIELDS[3] == fields[3] && FIELDS[5] == fields[5]
    end
  end
end
end
