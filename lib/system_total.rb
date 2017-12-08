# frozen_string_literal: true

class SystemTotal
  class << self
    def to_btc
      Coin.sum do |coin|
        Utils.to_decimal(coin.assets * coin.btc_rate, coin.subdivision)
      end
    end

    Coin.not_btc.each do |coin|
      define_method "to_#{coin.code.downcase}" do
        (to_btc / coin.btc_rate)
      end
    end
  end
end
