class Subreddit < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :posts,         dependent: :destroy
  has_many :users,         through: :subscriptions

  attr_accessor :moderator

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

  def moderator
    @moderator ||= User.find(mod)
  end
end
