# frozen_string_literal: true

module Sheet
  class Detector < Base
    SF_DETAILS_FIELDS = %w[序号 订单上传时间 客户订单号 平台订单号 顺丰运单号]
    SF_PRICE_FIELDS = %w[序号 日期 运单号码 寄件地区]

    def detect_class
      return Sheet::Shipment::Sf::Detail.new(@file) if is_sf_detail_sheet?
      return Sheet::Shipment::Sf::Price.new(@file) if is_sf_price_sheet?
    end

    private

    def is_sf_detail_sheet?
      SF_DETAILS_FIELDS.all? {|f| f.in?(header) }
    end

    def is_sf_price_sheet?
      (0..20).detect do |i|
        SF_PRICE_FIELDS.all? {|f| f.in?(row(i)) }
      end.present?
    end
  end
end
