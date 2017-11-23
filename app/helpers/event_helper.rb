# frozen_string_literal: true

module EventHelper
  def deposit_event?
    triggered_by.system_deposit?
  end

  def exchange_event?
    triggered_by.system_exchange? ||
      triggered_by.member_exchange?
  end

  def allocation_event?
    triggered_by.system_allocation? ||
      triggered_by.member_allocation?
  end

  def source_coin_event?
    triggered_by.source_coin == coin
  end

  def destination_coin_event?
    triggered_by.destination_coin == coin
  end

  def source_member_event?
    triggered_by.source_member == member
  end

  def destination_member_event?
    triggered_by.destination_member == member
  end
end
