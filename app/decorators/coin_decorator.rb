# frozen_string_literal: true

class CoinDecorator < Draper::Decorator
  delegate_all

  def member_liability
    h.current_member.liability(id).to_d / 10**subdivision
  end

  def available_assets
    assets.to_d / 10**subdivision
  end

  def overall_liability
    liability.to_d / 10**subdivision
  end

  def total_in_system
    total.to_d / 10**subdivision
  end
end
