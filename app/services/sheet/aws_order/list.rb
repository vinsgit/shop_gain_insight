# frozen_string_literal: true

module Sheet
module AwsOrder
  class List < Base
    def import!(shop_id)
      return false unless key_fields_not_existed?

      attrs = attributes(shop_id)

      result = []

      attrs.each do |att|
        r = ::AwsOrder.find_or_initialize_by(
          shop_id: shop_id,
          sku_id: att[:sku_id],
          desc: att[:desc],
          amt_type: att[:amt_type],
          order_ref: att[:order_ref],
          txn_type: att[:txn_type],
          merchant_order_ref: att[:merchant_order_ref]
        )

        r.update(**att)
      end

      return true
    end

    private

    def attributes(shop_id)
      result = compose_content do |c|
        next if c.blank?
        if c[match_result[:amount_type]] == 'CouponRedemptionFee'
          # TODO
          # 扣除coupon花费，通过名字拆分，对应到sku上
        end

        next if c[match_result[:amount_type]].in?(['Cost of Advertising', 'Current Reserve Amount', 'Previous Reserve Amount Balance', 'CouponRedemptionFee'])

        sku_name = c[match_result[:sku_name]]

        {
          settle_id: c[match_result[:settle_id]],
          sku_id: sku_records(shop_id).where(name: sku_name).first&.id,
          posted_at: c[match_result[:posted_at]],
          amt: c[match_result[:amt]],
          promotion_ref: c[match_result[:promotion_ref]],
          desc: c[match_result[:desc]],
          order_ref: c[match_result[:order_ref]],
          merchant_order_ref: c[match_result[:merchant_order_ref]],
          txn_type: c[match_result[:transaction_type]],
          amt_type: c[match_result[:amount_type]]
        }

      end

    end

    def match_fields
      { settle_id: 'settlement-id',
        sku_name: 'sku',
        posted_at: 'posted-date',
        amt: 'amount',
        promotion_ref: 'promotion-id',
        desc: 'amount-description',
        order_ref: ['Liquidations', 'order-id'],
        merchant_order_ref: 'merchant-order-id',
        transaction_type: 'transaction-type',
        amount_type: 'amount-type'
      }
    end

    def first_row
      3
    end

    def last_row
      super
    end

    def header
      super
    end

    def sku_records(shop_id)
      @sku_records ||= ::Sku.where(name: sku_names, shop_id: shop_id)
    end

    def sku_names
      @sku_names ||= names = compose_content do |c|
        {
          name: c[match_result[:sku_name]]
        }
      end.map{|x| x[:name]}.uniq
    end
  end
end
end
