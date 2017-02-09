class Subscription < ApplicationRecord
  belongs_to :user,      dependent: :destroy
  belongs_to :subreddit, dependent: :destroy
end
