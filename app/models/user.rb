class User < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :votes,         dependent: :destroy
  has_many :posts
  has_many :comments
  has_many :subreddits, through: :subscriptions

  before_save :downcase_name

  attr_accessor :remember_token

  BAD_NAME_REGEX  = /[^\w-]+/

  validates :name, presence: true,
                   length: { in: 2..20 },
                   format: { without: BAD_NAME_REGEX },
                   uniqueness: { case_sensitive: false }

  validates :password, confirmation: true,
                       presence: true,
                       length: { minimum: 6 }

  validates :password_confirmation, presence: true

  has_secure_password

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    @remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(@remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(token)
    return false if token.blank?
    BCrypt::Password.new(self.remember_digest).is_password?(token)
  end

  def karma
    self.post_karma + self.comment_karma
  end

  def to_s
    puts "-" * 20
    puts "ID: #{id}"
    puts "Name: #{name}"
    puts "Karma: #{self.karma}"
    puts "  Comment-Karma: #{comment_karma}"
    puts "  Post-Karma: #{post_karma}"
    puts "Created: #{created_at}"
    puts "Updated: #{updated_at}"
  end

  private

    def downcase_name
      self.name.downcase!
    end
end
