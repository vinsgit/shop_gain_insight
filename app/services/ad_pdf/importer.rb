# frozen_string_literal: true

module AdPdf
  class Importer
    def initialize(cost_arr)
      @cost_arr = cost_arr
    end

    def perform!
      @cost_arr.each do |arr|
        item_link = find_item_link(arr.first)
        # TODO: Add error logs when item_link is blank
        # If data is all good, item_link must exist
        next if item_link.blank?
        update_ads_cost(item_link, arr.last)
      end
    end

    private

    def find_item_link(name)
      ItemLink.find_by(name: name)
    end

    def update_ads_cost(item_link, total_amt)
      skus_count = item_link.skus.count
      return if skus_count.zero?
      average_cost = total_amt.to_d / skus_count

      item_link.skus.update_all("ads_cost = ads_cost + #{average_cost}")
    end
  end
end