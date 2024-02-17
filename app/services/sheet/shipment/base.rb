module Sheet
  module Shipment
    class Base < Sheet::Base
      def perform!(shop_id)
        import_service.import!(shop_id)
      end

      private

      def import_service
        Sheet::Detector.new(@file).detect_class
      end

    end
  end
  end