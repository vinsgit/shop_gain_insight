# frozen_string_literal: true

module Sheet
  class Base
    # include Abstractable

    def initialize(file)
      @file = file
      @sheet = Roo::Spreadsheet.open(file, encoding: 'iso-8859-1')
    end

    def header
      @sheet.row(1)
    end

    def content(&b)
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
  end
end
