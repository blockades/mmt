# frozen_string_literal: true

FactoryGirl.define do
  factory :member_plan do
    amount { BigDecimal.new rand(2145.123...51_235.927).to_s }
    currency { "United States Dollar" }
    iso_currency { "USD" }
    plan { create :plan }
  end
end
