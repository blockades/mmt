# frozen_string_literal: true

FactoryGirl.define do
  factory :plan_detail do
    coin_id { create(:coin).id }
  end
end
