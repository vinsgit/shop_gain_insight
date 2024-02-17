class Shipment < ApplicationRecord
  belongs_to :shop

  enum channel: { sf: 0 }

  def self.channel_options
    {
      'sf' => '顺丰'
    }
  end

  def channel_in_text
    Shipment.channel_options[channel]
  end
end
