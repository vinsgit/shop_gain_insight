# frozen_string_literal: true

module Sheet
  class Processor

    # Initialize the Processor with the provided file and shop_id
    def initialize(file, shop_id)
      return if file.blank?

      @shop_id = shop_id
      @file = file
      @sheet = Roo::Spreadsheet.open(file, encoding: 'iso-8859-1')
      @sheets_count = @sheet.sheets.count
    end

    # Perform import of data from all sheets in the spreadsheet
    def perform!
      return false if @file.blank?

      success = true

      @sheets_count.times do |n|
        sheet = @sheet.sheet(n)

        # Skip empty sheets
        next if sheet.first_row.blank? && sheet.last_row.blank?

        # Perform the import for the detected service
        success = import_service(sheet).import!(@shop_id) && success
      end

      success
    end

    # Detect the appropriate service based on the sheet header
    def import_service(sheet)
      Sheet::Detector.new(sheet).detect_class
    end

  end
end
