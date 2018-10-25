require 'faker'

FactoryBot.define do
  sequence(:type) {|n| "Arrival" }
  sequence(:exact_time) {|n| Faker::Time.unique.between(DateTime.now.beginning_of_day, DateTime.now.end_of_day) }
  sequence(:destination) {|n| Faker::Address.full_address }
  sequence(:flight_no) {|n| Faker::Code.asin }
  sequence(:airline) {|n| Faker::Company.industry }
  sequence(:status) {|n| Faker::String.random(4) }
  sequence(:date) {|n| Time.now }

  factory :flight do
    type { FactoryBot.generate(:type) }
    date { FactoryBot.generate(:date) }
    exact_time { FactoryBot.generate(:exact_time) }
    destination { FactoryBot.generate(:destination) }
    flight_no { FactoryBot.generate(:flight_no) }
    airline { FactoryBot.generate(:airline) }
    status { FactoryBot.generate(:status) }
  end
end
