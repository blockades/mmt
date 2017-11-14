# frozen_string_literal: true

class CoinDecorator < Draper::Decorator
  delegate_all

  def member_balance
    h.current_member.holdings(id).to_d / 10**subdivision
  end

  def central_reserve
    reserves.to_d / 10**subdivision
  end

  def holdings_available
    holdings.to_d / 10**subdivision
  end
end
