# frozen_string_literal: true

module AdPdf
  class Reader
    MARK_TO_SPLIT = '--'
    CURRENCY_MARK = ' USD'
    AD_HEADER = ['Campaign', 'Campaign type', 'Clicks', 'Average CPC', 'Amount (ex. Tax)']

    def initialize(file)
      @file = file
      @content = content
    end

    def date
      key_to_split = 'Invoice Date:'
      str = content[0].flatten.select{|x| x.split(key_to_split).count == 2}.first
      date_string = str.split(key_to_split).last.strip
      @date ||= Date.strptime(date_string, '%d-%b-%Y')
    end

    # SKU分割规则：--
    # 如 abc--手动, abc为sku
    # Extract SKU and cost pairs from the table
    def sku_cost_arr
      header_index = find_header_index
      return [] unless header_index

      cost_arr = content[header_index]
      sku_index = cost_arr.first.find_index('Campaign')
      cost_index = cost_arr.first.find_index('Amount (ex. Tax)')
      content[header_index][1..-1].map do |row|
        sku = row[sku_index].split(MARK_TO_SPLIT).first
        cost = row[cost_index].delete(CURRENCY_MARK)
        [sku, cost]
      end
    end

    private

    def content
      @content ||= Iguvium.read(@file).flat_map { |page| page.extract_tables! }.map(&:to_a)
    end

    # Find the index of the array containing the header
    def find_header_index
      content.find_index { |inner_array| (inner_array.first & AD_HEADER).size == AD_HEADER.size }
    end
  end
end