# frozen_string_literal: true

module Sheet
  class FileSheetDetector
    def initialize(file, shop_id)
      @shop_id = shop_id
      @sheet = Roo::Spreadsheet.open(file, encoding: 'iso-8859-1')
      @sheets_count = @sheet.sheets.count
    end

    def perform!
      success = true

      @sheets_count.times do |n|
        sheet = @sheet.sheet(n)

        next if (sheet&.row(1)&.compact&.blank? rescue true)

        success = import_service(sheet).import!(@shop_id) && success
      end

      success
    end

    def import_service(sheet)
      Sheet::Detector.new(sheet).detect_class
    end

  end
end
