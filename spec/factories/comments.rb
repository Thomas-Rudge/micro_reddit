FactoryGirl.define do
  factory :comment do
    user
    post, post_type = 0, post_text = Faker::Lorem.paragraph

    content { Faker::Lorem.paragraph }
    upvotes   { [*(0...3500)].sample }
    downvotes { [*(0...500)].sample }
  end
end
