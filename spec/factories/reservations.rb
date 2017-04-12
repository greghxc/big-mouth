FactoryGirl.define do
  factory :reservation do
    number Faker::Cat.name
    external_number '+1' + Faker::Number.number(10)
    driver_number '+1' + Faker::Number.number(10)
  end
end
