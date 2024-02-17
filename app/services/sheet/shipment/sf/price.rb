module Sheet
module Shipment
module Sf
  class Price < Sheet::Base
    def import!(shop_id)
      return false unless key_fields_not_existed?

      attributes.each do |att|
        r = ::Shipment.find_or_initialize_by(order_ref: att[:order_ref])
        r.total_fee = att[:total_fee]
        preset_attributes_for_shipments(r, 'sf')
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
      compose_content do |c|
        { order_ref: c[match_result[:order_ref]], total_fee: c[match_result[:total_fee]] }
      end
    end

    def match_fields
      {
        order_ref: '运单号码',
        total_fee: '应付金额'
      }
    end
  end
end
end
end