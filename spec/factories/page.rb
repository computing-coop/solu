FactoryBot.define do

  factory :page do
    title { Faker::Book.title }
    body { Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 4) }

  end

end