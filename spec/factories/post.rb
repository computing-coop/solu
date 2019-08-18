FactoryBot.define do
  factory :post do
    title { Faker::Book.title }
    body { Faker::Lorem.paragraph(2, true, 4) }
    published { true }
    published_at { Time.now }
    sticky { false }
    short_abstract { Faker::Lorem.sentence  }
    user { User.first }
    subsite { Subsite.first }
    node { Node.first }
    project { nil }

  end
end