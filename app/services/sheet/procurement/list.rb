# frozen_string_literal: true

module Sheet
module Procurement
  class List < Base
    def import!(shop_id)
      return false unless key_fields_not_existed?

      attrs = attributes(shop_id)

      # validate_attributes!(attrs, :sku_id, :item_link_id)

      attrs.each do |att|
        # Remove this after data is correct
        next if att[:sku_id].blank? || att[:item_link_id].blank?
        # Remove this after data is correct

        r = ::Procurement.find_or_initialize_by(sku_id: att[:sku_id], shop_id: shop_id, purchased_at: att[:purchased_at])

        r.update(**att)
      end

      return true
    end

    private

    def attributes(shop_id)
      array = compose_content do |c|
        # TODO
        # Remove this after new sheet comes
        # 
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

    # TODO
    # Extra this into base class
    def composed_attributes(array)
      most_recent_item_link_name = nil
      most_recent_purchased_at = nil

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
      end

      array
    end

  end
end
end
