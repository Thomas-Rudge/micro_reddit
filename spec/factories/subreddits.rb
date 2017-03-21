FactoryGirl.define do
  factory :subreddit do
    name        { Faker::Pokemon.unique.name.gsub(/[^\w-]+/,"") }
    description { Faker::Lorem.paragraph }
    sidebar     { Faker::Lorem.paragraph }
    nsfw        { ([false]*7 << true).sample }
    mod         { [*(0..79)].sample }
  end
end
