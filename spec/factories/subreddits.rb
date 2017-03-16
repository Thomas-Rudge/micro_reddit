FactoryGirl.define do
  factory :subreddit do
    name        { Faker::Pokemon.unique.name.gsub(/[^\w-]+/,"") }
    description { Faker::Lorem.paragraph }
    sidebar     { Faker::Lorem.paragraph }
    nsfw        { [false]*5 << true }
    mod         { [*(0..100)].sample }
  end
end
