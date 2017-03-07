class Subreddit < ApplicationRecord
  has_many :subscriptions
  has_many :posts
  has_many :users, through: :subscriptions

  BAD_NAME_REGEX  = /[^\w-]+/

  before_save { name.downcase! }

  validates :name, presence: true,
                   length: { in: 3..21 },
                   format: { without: BAD_NAME_REGEX },
                   uniqueness: { case_sensitive: false }

  validates :description, length: { maximum: 500 }
  validates :sidebar,     length: { maximum: 500 }
  validates :nsfw,        inclusion: { in: [ true, false ] }
  validates :mod,         presence: true
end
