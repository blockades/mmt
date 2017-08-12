FactoryGirl.define do

  factory :plan do
    name Faker::Space.planet
    after(:build) do |plan|
      2.times { plan.details << create(:plan_detail, rate: 50.00) }
    end
  end

end
