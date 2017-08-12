FactoryGirl.define do

  factory :user_plan do
    amount { BigDecimal.new rand(2145.123...51235.927).to_s }
    currency { 'United States Dollar' }
    iso_currency { 'USD' }
    plan { create :plan }
  end

end
