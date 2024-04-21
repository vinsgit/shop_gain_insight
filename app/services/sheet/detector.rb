# frozen_string_literal: true

module Sheet
  class Detector

    # Define field names for various types of sheets
    SF_DETAILS_FIELDS = %w[序号 订单上传时间 客户订单号 平台订单号 顺丰运单号]
    SF_PRICE_FIELDS = %w[序号 日期 运单号码 寄件地区]
    SKU_FIELDS = %w[sku fnsku asin product-name condition]
    PROCUREMENT_FIELDS = %w[采购时间 链接SKU 商品SKU 采购数量]
    DELIVERY_RECORDS_FIELDS = %w[发货日期 商品名称 商品SKU]
    FBM_DELIVERY_RECORDS_FIELDS = %w[订单号 商品SKU 采购情况 发送方式]
    AWS_ORDER_FIELDS = %w[settlement-id	settlement-start-date amount]

    # Initialize the Detector with the provided sheet
    def initialize(sheet)
      @sheet = sheet
    end

    # Detect the appropriate sheet class based on the sheet header
    def detect_class
      return Sheet::Shipment::Sf::Detail.new(@sheet) if is_sf_detail_sheet?
      return Sheet::Shipment::Sf::Price.new(@sheet) if is_sf_price_sheet?
      return Sheet::Sku::List.new(@sheet) if is_sku_sheet?
      return Sheet::Procurement::List.new(@sheet) if is_procurement_sheet?
      return Sheet::DeliveryRecord::List.new(@sheet) if is_delivery_record_sheet?
      return Sheet::FbmDeliveryRecord::List.new(@sheet) if is_fbm_delivery_record_sheet?
      return Sheet::AwsOrder::List.new(@sheet) if is_aws_order_sheet?
    end

    private

    # Check if the sheet header matches the format for the SF detail fields
    def is_sf_detail_sheet?
      SF_DETAILS_FIELDS.all? {|f| f.in?(header) }
    end

    # Check if the sheet header matches the format for the SF price fields
    def is_sf_price_sheet?
      (0..20).detect do |i|
        SF_PRICE_FIELDS.all? {|f| f.in?(row(i)) }
      end.present?
    end

    # Check if the sheet header matches the SKU fields
    def is_sku_sheet?
      SKU_FIELDS.all? {|f| f.in?(header) }
    end

    # Check if the sheet header matches the format for procurment fields
    def is_procurement_sheet?
      PROCUREMENT_FIELDS.all? {|f| f.in?(header) }
    end

    # Check if the sheet header matches the format for delivery records
    def is_delivery_record_sheet?
      DELIVERY_RECORDS_FIELDS.all? {|f| f.in?(header) }
    end

    # Check if the sheet header matches the format for FMB delivery records
    def is_fbm_delivery_record_sheet?
      FBM_DELIVERY_RECORDS_FIELDS.all? {|f| f.in?(header) }
    end

    # Check if the sheet header matches the format for AWS order
    def is_aws_order_sheet?
      AWS_ORDER_FIELDS.all? {|f| f.in?(header) }
    end

    def header
      @sheet.row(1)
    end

    def row(num)
      @sheet.row(num)
    end
  end
end
