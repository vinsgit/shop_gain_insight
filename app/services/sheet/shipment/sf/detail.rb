module Sheet
module Shipment
module Sf
  class Detail < Base
    FIELDS = %w[序号 订单上传时间 客户订单号 平台订单号 顺丰运单号 代理运单号]

    def import!(shop_id)
      return false unless key_fields_not_misplaced?

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

    def attributes
      @attributes ||= content do |k|
        {
          order_ref: k[4],
          aws_order_ref: k[3]
        }
      end
    end

    def key_fields_not_misplaced?
      return false if header.blank?

      FIELDS[3] == header[3] && FIELDS[4] == header[4]
    end
  end
end
end
end