# frozen_string_literal: true

module AdPdf
  class Reader
    MARK_TO_SPLIT = '--'
    CURRENCY_MARK = ' USD'

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
    def sku_cost_arr
      content[1][1..-1].map do |x|
        sku = x.first.split(MARK_TO_SPLIT)[0]
        cost = x.last.remove!(CURRENCY_MARK)
        [sku, cost]
      end
    end

    private

    def content
      @content ||= Iguvium.read(@file).flat_map { |page| page.extract_tables! }.map(&:to_a)
    end

  end
end