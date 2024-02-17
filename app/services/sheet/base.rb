# frozen_string_literal: true

module Sheet
  class Base
    include Abstractable

    abstract_methods :match_fields,
                     :header,
                     :first_row,
                     :last_row,
                     :attributes

    def initialize(file)
      @file = file
      @sheet = Roo::Spreadsheet.open(file, encoding: 'iso-8859-1')
    end

    def perform!(shop_id)
      import_service.import!(shop_id)
    end

    def header
      @sheet.row(1)
    end

    def compose_content(&b)
      (first_row..last_row).map do |i|
        yield(row(i))
      end.compact_blank!
    end

    def first_row
      2
    end

    def last_row
      @sheet.last_row
    end

    def row(num)
      @sheet.row(num)
    end

    def match_indices_hash(arr)
      indices = {}
      match_fields.each do |key, value|
        index = arr.index(value)
        indices[key] = index if index
      end
      indices
    end

    def import_service
      Sheet::Detector.new(@file).detect_class
    end

    def match_result
      @match_result ||= match_indices_hash(header)
    end

    def key_fields_not_existed?
      match_fields.size == match_result.size
    end

    def preset_attributes_for_shipments(shipment, channel)
      shipment.shop_id ||= shop_id
      shipment.channel ||= channel
      shipment.transaction_at ||= Time.current
    end
  end
end
