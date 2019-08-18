FactoryBot.define do
  factory :partner do
    name { Faker::Company.name  }
    website { Faker::Internet.url }
    address1 { Faker::Address.street_address }
    city {Faker::Address.city }
    country { Faker::Address.country_code }
    postcode { Faker::Address.postcode }
    description { Faker::Company.catch_phrase }
    is_funder { [true, false].sample }
    is_general { [true, false].sample }
    trait :yeared do
      start_year { Faker::Time.between(from: 13.years.ago, to: 10.years.ago).year }
      end_year { Faker::Time.between(from: 9.years.ago, to: Time.now).year }
    end
  end
end
