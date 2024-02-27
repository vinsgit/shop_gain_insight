# frozen_string_literal: true

module Sheet
module DeliveryRecord
  class List < Base
    def import!(shop_id)
      return false unless key_fields_not_existed?

      attributes(shop_id).each do |att|
        # Remove this after data is correct
        next if att[:sku_id].blank?
        # Remove this after data is correct

        r = ::DeliveryRecord.find_or_initialize_by(shop_id: shop_id, sku_id: att[:sku_id], deliver_at: att[:deliver_at])

        r.update(**att)
      end

      return true
    end

    private

    def attributes(shop_id)
      
      array = compose_content do |c|
        sku_id = ::Sku.find_by(shop_id: shop_id, name: c[match_result[:sku_name]])&.id
        {
          sku_id: sku_id.blank? ? c[match_result[:sku_name]] : sku_id,
          deliver_at: c[match_result[:deliver_at]],
          received_qty: c[match_result[:received_qty]],
          sent_count: c[match_result[:sent_count]],
          status: c[match_result[:status]]
        }
      end

      composed_attributes(array)
    end

    def match_fields
      { sku_name: '商品SKU',
        deliver_at: '发货日期',
        received_qty: '实到数量',
        sent_count: '箱1',
        status: '类型'
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
      most_recent_deliver_at = nil

      array.each do |item|
        if item[:deliver_at].nil?
          item[:deliver_at] = most_recent_deliver_at if most_recent_deliver_at
        else
          most_recent_deliver_at = item[:deliver_at]
        end
      end

      array
    end
  end
end
end
