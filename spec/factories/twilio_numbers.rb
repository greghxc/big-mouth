FactoryGirl.define do
  factory :twilio_number do
    number { '+1' + (1..10).map { rand(1..9) }.join }
  end
end
