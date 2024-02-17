module Sheet
module Shipment
module Sf
  class Price < Base
    FIELDS = %w[序号 日期 运单号码 寄件地区 到件地区 对方公司名称 计费重量 产品类型 付款方式 费用(元) 折扣/促销 应付金额 经手人 增值费用]

    def import!(shop_id)
      return false unless key_fields_not_misplaced?

      attributes.each do |att|
        r = ::Shipment.find_or_initialize_by(order_ref: att[:order_ref])
        r.total_fee = att[:total_fee]
        r.shop_id ||= shop_id
        r.channel ||= 'sf'
        r.transaction_at ||= Time.current
        r.save
      end

      return true
    end

    private

    def attributes
      @attributes ||= composed_content.group_by { |h| h[:order_ref] }.map do |k, v|
        {:order_ref => k, :total_fee => v.sum { |h| h[:total_fee].to_d }}
      end
    end

    def header
      row(first_row - 1) if first_row.present?
    end

    def first_row
      detected_first_row + 1 if detected_first_row
    end

    def last_row
      detected_last_row - 1 if detected_last_row
    end

    def detected_first_row
      @detected_first_row ||= (0..20).detect do |i|
        Sheet::Detector::SF_PRICE_FIELDS.all? {|f| f.in?(row(i)) }
      end
    end

    def detected_last_row
      last = @sheet.last_row
      @last_row ||= ((last - 30)..last).detect do |i|
        next if row(i).first.blank?
        ['合计', '合 计'].any? {|k| k.in?(row(i).first) }
      end
    end

    def composed_content
      content do |c|
        {order_ref: c[2], total_fee: c[11]}
      end
    end

    def key_fields_not_misplaced?
      return false if header.blank?

      FIELDS[2] == header[2] && FIELDS[11] == header[11]
    end
  end
end
end
end