# frozen_string_literal: true

module AdPdf
  class Processor
    def initialize(file)
      @file = file
    end

    def update!
      import_service.perform!
    end

    private

    def import_service
      @import_service ||= Importer.new(reader_service.sku_cost_arr)
    end

    def reader_service
      @reader_service ||= ReaderService.new(file)
    end
  end
  end