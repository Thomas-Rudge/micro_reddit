class User < ApplicationRecord
  belongs_to :user

  validates :user_id,      presence: true
  validates :subject_id,   presence: true
  validates :subject_type, presence: true,
                           inclusion: { in: [ 0, 1 ] }
  validates :vote,         presence: true,
                           inclusion: { in: [ 0, 1 ] }
end
