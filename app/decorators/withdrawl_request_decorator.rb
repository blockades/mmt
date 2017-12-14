# frozen_string_literal: true

class WithdrawlRequestDecorator < Draper::Decorator
  delegate_all

  def withdrawl_quantity
    Utils.to_decimal(quantity, coin.subdivision)
  end
end
