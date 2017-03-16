class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :comment, optional: true

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :vote,    presence: true,
                      inclusion: { in: [ 0, 1 ] }
end
