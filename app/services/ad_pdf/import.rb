# frozen_string_literal: true

module AdPdf
  class Import
    def initialize(cost_arr)
      @cost_arr = cost_arr
    end

    def perform!
      @cost_arr.each do |arr|
        sku = sku_records.find_by(name: arr.first)
        next unless sku

        cost += sku.ads_cost
        sku.update(ads_cost: cost)
      end
    end

    private

    def sku_records
      sku_names = @cost_arr.map(&:first)
      @sku_records ||= ::Sku.where(name: sku_names)
    end
  end
end