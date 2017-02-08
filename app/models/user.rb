class User < ApplicationRecord
  NAME_REGEX  = /[\t|\r|\n|\f]+/m

  before_save do
    email.downcase!
    name.downcase!
  end

  validates :name, presence: true,
                  length: { in: 2..20 },
                  format: { without: NAME_REGEX }

  validates :password, confirmation: true,
                       presence: true,
                       length: { minimum: 6 }

  validates :password_confirmation, presence: true

  has_secure_password
end
