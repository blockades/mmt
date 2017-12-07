# frozen_string_literal: true

class CoinDecorator < Draper::Decorator
  delegate_all

  def member_liability
    Utils.to_decimal(h.current_member.liability(self), subdivision)
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
