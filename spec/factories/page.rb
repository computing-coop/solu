FactoryBot.define do

  factory :page do
    title { Faker::Book.title }
    body { Faker::Lorem.paragraph(2, true, 4) }

  end

end