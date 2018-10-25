require 'faker'

FactoryBot.define do
  sequence(:exact_time) {|n| Faker::Time.unique.between(DateTime.now.beginning_of_day, DateTime.now.end_of_day) }
  sequence(:destination) {|n| Faker::Address.full_address }
  sequence(:flight_no) {|n| Faker::Code.asin }
  sequence(:airline) {|n| Faker::Company.industry }

  factory :flight do
    type "Arrival"
    date Time.now
    exact_time { FactoryBot.generate(:exact_time) }
    expected_time nil
    destination { FactoryBot.generate(:destination) }
    flight_no { FactoryBot.generate(:flight_no) }
    airline { FactoryBot.generate(:airline) }
    status "Closed"
  end
end
