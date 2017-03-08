FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.paragraph }
    upvotes   { [*(0...3500)].sample }
    downvotes { [*(0...500)].sample }
    user_id { 0 }
    post_id { 0 }
  end
end
