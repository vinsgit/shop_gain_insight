# frozen_string_literal: true

module Sheet
  class Base
    # include Abstractable

    def initialize(file)
      @file = file
      @sheet = Roo::Spreadsheet.open(file)
    end

    def header
      @sheet.row(1)
    end

    def content
      (first_row..last_row).map do |i|
        row(i)
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
  end
end
