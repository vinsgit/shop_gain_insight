module Sheet
module Shipment
module Sf
  class Detail < Sheet::Base
    def import!(shop_id)
      return false unless key_fields_not_existed?

      attributes.each do |att|
        r = ::Shipment.find_or_initialize_by(order_ref: att[:order_ref])
        r.aws_order_ref = att[:aws_order_ref]
        r.shop_id ||= shop_id
        r.channel ||= 'sf'
        r.transaction_at ||= Time.current
        r.save
      end

      return true
    end

    private

    def first_row
      super
    end

    def last_row
      super
    end

    def header
      super
    end

    def attributes
      @attributes ||= compose_content do |c|
        {
          order_ref: c[match_result[:order_ref]],
          aws_order_ref: c[match_result[:aws_order_ref]]
        }
      end
    end

    def match_fields
      {
        order_ref: '平台订单号',
        aws_order_ref: '顺丰运单号'
      }
    end
  end
end
end
end