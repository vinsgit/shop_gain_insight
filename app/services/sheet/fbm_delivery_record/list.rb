# frozen_string_literal: true

module Sheet
module FbmDeliveryRecord
  class List < Base
    def import!(shop_id)
      return false unless key_fields_not_existed?

      attrs = attributes(shop_id)

      # validate_attributes!(attrs, :sku_id, :item_link_id)

      attrs.each do |att|
        # Remove this after data is correct
        next if att[:sku_id].blank?
        # Remove this after data is correct

        r = ::FbmDeliveryRecord.find_or_initialize_by(shop_id: shop_id, sku_id: att[:sku_id], aws_order_ref: att[:aws_order_ref])

        r.update(**att)
      end

      return true
    end

    private

    def attributes(shop_id)
      split_ele_arr = []

      result = compose_content do |c|
        build_attributes(c, shop_id, c[match_result[:sku_name]])
      end

      result = split_sku_ids(result)
      assign_sku_id_to_result(result, shop_id)
    end

    def build_attributes(c, shop_id, sku_name)
      {
        sku_id: sku_name,
        purchased_at: convert_excel_date(c[match_result[:purchased_at]]),
        amt: c[match_result[:amt]].to_d,
        note: c[match_result[:note]],
        purchase_note: c[match_result[:purchase_note]],
        delivery_method: c[match_result[:delivery_method]],
        delivery_status: c[match_result[:delivery_status]],
        aws_order_ref: c[match_result[:aws_order_ref]],
        order_note: c[match_result[:order_note]]
      }
    end

    def match_fields
      { sku_name: '商品SKU',
        purchased_at: '采购日期',
        amt: '采购金额',
        note: '备注',
        purchase_note: '采购情况',
        delivery_method: '发送方式',
        delivery_status: '发货状态',
        aws_order_ref: '订单号',
        order_note: '做单情况',
        item_link_name: '链接名称'
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

    def assign_sku_id_to_result(array, shop_id)
      array.map do |item|
        item[:sku_id] = ::Sku.find_by(name: item[:sku_id], shop_id: shop_id)&.id || item[:sku_id]
      end

      array
    end

    def split_sku_ids(array)
      return array unless array.any? { |item| item[:sku_id].is_a?(String) && item[:sku_id].include?('/') }

      new_array = []

      array.each do |item|
        unless item[:sku_id].is_a?(String) && item[:sku_id].include?('/')
          new_array << item
          next
        end

        sku_ids = item[:sku_id].split('/')
        sku_ids.each do |sku_id|
          new_item = item.clone
          new_item[:sku_id] = sku_id
          new_array << new_item
        end
      end

      new_array
    end

  end
end
end
