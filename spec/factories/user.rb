FactoryBot.define do
  
  factory :user do 
    email { Faker::Internet.email }
    name { Faker::TheThickOfIt.character }
    encrypted_password "password"
    confirmed_at Date.today
    before :save do |b|
      b.remote_avatar_url = "https://picsum.photos/300/300"
    end 
    trait :admin do
      after(:create) {|user| user.add_role(:admin)}
    end

  end
end