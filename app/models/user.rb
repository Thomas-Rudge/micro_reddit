class User < ApplicationRecord
  has_many :subscriptions
  has_many :posts
  has_many :comments
  has_many :subreddits, through: :subscriptions

  BAD_NAME_REGEX  = /\W/

  before_save { name.downcase! }

  validates :name, presence: true,
                   length: { in: 2..20 },
                   format: { without: BAD_NAME_REGEX },
                   uniqueness: { case_sensitive: false }

  validates :password, confirmation: true,
                       presence: true,
                       length: { minimum: 6 }

  validates :password_confirmation, presence: true

  has_secure_password
end
