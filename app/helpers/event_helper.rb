# frozen_string_literal: true

module EventHelper
  def deposit?
    triggered_by.system_deposit?
  end

  def exchange?
    triggered_by.member_exchange?
  end

  def allocation?
    triggered_by.system_allocation? ||
      triggered_by.member_allocation?
  end
end
