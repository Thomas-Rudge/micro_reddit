class Subreddit < ApplicationRecord
  BAD_NAME_REGEX = /\W/

  before_save { name.downcase! }

  validates :name, presence: true,
                   length: { in: 3..21 },
                   format: { without: BAD_NAME_REGEX },
                   uniqueness: { case_sensitive: false }

  validates :description, length: { maximum: 500 }

  validates :nsfw, inclusion: { in: [ true, false ] }
end
