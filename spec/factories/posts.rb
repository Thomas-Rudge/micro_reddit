include PostsHelper

FactoryGirl.define do
  factory :post do
    user
    subreddit

    title        { Faker::Lorem.sentence }
    upvotes   { [*(0...3500)].sample }
    downvotes { [*(0...500)].sample }
    post_type { 0 }
    post_text { "Placeholder. Use 'text_post' or 'link_post' factories instead." }

    factory :text_post do
      post_type { 0 }
      post_text { Faker::Lorem.paragraph }
    end

    factory :link_post do
      post_type { 1 }
      link      { Faker::Internet.url }
    end
  end
end
