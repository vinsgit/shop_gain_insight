# frozen_string_literal: true

module Sheet
module Procurement
  class List < Base
    def import!(shop_id)
      return false unless key_fields_not_existed?

      # get the extracted data from the sheet and compose the attributes to an array
      attrs = attributes(shop_id)

      # validate_attributes!(attrs, :sku_id, :item_link_id)
      attrs.each do |att|

        # Remove this after data is correct
        next if att[:sku_id].blank? || att[:item_link_id].blank?

        # Remove this after data is correct
        investor_str = att.delete(:investors)

        procurement_investors = extract_investors(investor_str).map{|attrs| ProcurementInvestor.new(**attrs) }

        r = ::Procurement.find_or_initialize_by(sku_id: att[:sku_id], shop_id: shop_id, purchased_at: att[:purchased_at])

        r.procurement_investors = procurement_investors

        r.update(**att)
      end

      true
    end

    private

    # extract the data from the  procurement sheet and compose the attributes into an array
    def attributes(shop_id)
      array = compose_content do |c|
        # TODO
        # Remove this after the finalized sheet comes
        next if c[0] == '折后价-合计'
        sku_id = ::Sku.find_by(shop_id: shop_id, name: c[match_result[:sku_name]])&.id
        item_link_id = ::ItemLink.find_by(shop_id: shop_id, name: c[match_result[:item_link_name]])&.id
        {
          sku_id: sku_id.blank? ? c[match_result[:sku_name]] : sku_id,
          item_link_id: item_link_id.blank? ? c[match_result[:item_link_name]] : item_link_id,
          purchased_at: convert_excel_date(c[match_result[:purchased_at]]),
          received_qty: [c[match_result[:qty1]], c[match_result[:qty2]], c[match_result[:qty3]]].map(&:to_i).compact.sum,
          qty: c[match_result[:purchase_qty]],
          unit_price: c[match_result[:unit_price]].to_d,
          total_price: c[match_result[:total_price]].to_d,
          note: c[match_result[:note]],
          investors: c[match_result[:investors]]
        }
      end
      composed_attributes(array)
    end

    def match_fields
      {
        purchased_at: '采购时间',
        sku_name: '商品SKU',
        item_link_name: '链接SKU',
        investors: '付款人',
        unit_price: '单价',
        total_price: '总价',
        qty1: '实到数量（1）',
        qty2: '实到数量（2）',
        qty3: '实到数量（3）',
        purchase_qty: '采购数量' ,
        note: '备注'
      }
    end

    def first_row
      super
    end

    def last_row
      super
    end

    def header
      super
    end

    def extract_investors(str)
      investors_arr = str.split('，')
      investors_arr.map do |investor|
        investor_name, ratio = investor.split('：')
        investor = ::Investor.find_by(name: investor_name)

        if investor.blank?
          {}
        else
          { investor_id: investor.id, ratio: ratio.to_f / 100 }
        end

      end.compact_blank!
    end

    # Background: In a sheet table, some cells are merged into one.
    # The actual operation is to only let the value exist in the first column,
    # modify the style of all merged columns, and center-align the value.
    # So the function of this is to, like the fill-button at the bottom right of the cell, copy the value of the first row to all merged columns.
    #
    # TODO
    # move this into base class
    def composed_attributes(array)
      most_recent_item_link_name = nil
      most_recent_purchased_at = nil
      most_recent_investor = nil

      array.each do |item|
        if item[:item_link_name].nil?
          item[:item_link_name] = most_recent_item_link_name if most_recent_item_link_name
        else
          most_recent_item_link_name = item[:item_link_name]
        end

        if item[:purchased_at].nil?
          item[:purchased_at] = most_recent_purchased_at if most_recent_purchased_at
        else
          most_recent_purchased_at = item[:purchased_at]
        end

        if item[:investors].nil?
          item[:investors] = most_recent_investor if most_recent_investor
        else
          most_recent_investor = item[:investors]
        end
      end

      array
    end

  end
end
end
