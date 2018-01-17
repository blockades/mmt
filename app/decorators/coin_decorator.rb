# frozen_string_literal: true

class CoinDecorator < Draper::Decorator
  delegate_all

  def member_liability
    Utils.to_decimal(h.current_member.liability(self), subdivision)
  end

  def member_total_display
    h.current_member.coins.sum do |coin|
      Utils.to_decimal(
       h.current_member.liability(coin) * coin.btc_rate,
        coin.subdivision
      ) / self.btc_rate
    end
  end

  def system_assets
    Utils.to_decimal(assets, subdivision)
  end

  def system_liability
    Utils.to_decimal(liability, subdivision)
  end

  def system_equity
    Utils.to_decimal(equity, subdivision)
  end
end
