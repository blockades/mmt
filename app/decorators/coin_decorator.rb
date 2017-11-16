# frozen_string_literal: true

class CoinDecorator < Draper::Decorator
  delegate_all

  def member_balance
    h.current_member.balance(id).to_d / 10**subdivision
  end

  def availability
    available.to_d / 10**subdivision
  end

  def assigned_holdings
    liability.to_d / 10**subdivision
  end

  def total_in_system
    total.to_d / 10**subdivision
  end
end
