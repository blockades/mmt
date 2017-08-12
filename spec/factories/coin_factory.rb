FactoryGirl.define do

  factory :coin do
    name Faker::Name.name
    code { Array.new(3){[*"A".."Z", *"0".."9"].sample}.join }
  end

end
