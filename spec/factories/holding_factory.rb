FactoryGirl.define do

  factory :holding do
    amount { BigDecimal.new rand(123.45..15046.23).to_s }
  end

end
