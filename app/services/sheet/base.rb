# frozen_string_literal: true

module Sheet
  class Base
    include Abstractable

    # Define abstract methods that subclasses must implement
    abstract_methods :match_fields,
                     :header,
                     :first_row,
                     :last_row,
                     :attributes

    # Initialize the Base class with the provided sheet
    def initialize(sheet)
      @sheet = sheet
    end

    # Retrieve the header row of the sheet
    def header
      @sheet.row(1)
    end

    # Compose content based on provided block, skipping empty rows
    def compose_content(&b)
      (first_row..last_row).map do |i|
        yield(row(i))
      end.compact_blank!.delete_if { |hash| hash.values.all?(&:blank?) }
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

    # arr is an array of the sheet header field names
    # match_fields is defined in each subclass which inherits from the base class
    # match_indices_hash method creates a hash map that stores the column index of each header field as a value to the keys defined in match_fields
    def match_indices_hash(arr)
      indices = {}

      match_fields.each do |key, value|
        index =
          if value.is_a?(Array)
            value.map {|v| arr.index(v)}.compact.first
          else
            arr.index(value)
          end

        indices[key] = index if index
      end

      indices
    end

    def match_result
      @match_result ||= match_indices_hash(header)
    end

    # Check if all required fields exist in the header
    def key_fields_not_existed?
      match_fields.size == match_result.size
    end

    # Convert Excel date format to Ruby Date object
    def convert_excel_date(number)
      return nil if number.blank? || number == '/'
      Date.new(1899, 12, 30) + number.to_i
    end

    # Validate attributes to ensure no string values are present
    # This method is not currently in use because the Excel format is not yet finalized
    def validate_attributes!(attrs, *keys)
      invalid_values = []

      attrs.each do |attr|
        keys.each do |key|
          value = attr[key]
          invalid_values << value if value.is_a?(String)
        end
      end

      raise ::Sheet::Errors::AttributeError, invalid_values unless invalid_values.empty?
    end
  end
end
