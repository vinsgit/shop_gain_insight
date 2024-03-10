module Sheet
  module Shipment
  module Sf
    class Base < Sheet::Base
      def preset_attributes_for_shipments(shipment, channel, shop_id)
        shipment.shop_id ||= shop_id
        shipment.channel ||= channel
        shipment.transaction_at ||= Time.current
      end
    end
  end
  end
  end