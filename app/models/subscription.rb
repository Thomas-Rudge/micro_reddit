class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subreddit, counter_cache: true
end
