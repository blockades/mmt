# frozen_string_literal: true

class SystemTotal
  class << self
    def to_btc
      Coin.sum do |coin|
        Utils.to_decimal(coin.assets, coin.subdivision) * coin.btc_rate
      end
    end

    Coin.not_btc.each do |coin|
      define_method "to_#{coin.code.downcase}" do
        (to_btc / coin.btc_rate).floor(coin.subdivision)
      end
    end
  end
end
