class Vote < ApplicationRecord
  belongs_to :user,    dependent: :destroy
  belongs_to :post,    dependent: :destroy
  belongs_to :comment, dependent: :destroy, optional: true

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :vote,    presence: true,
                      inclusion: { in: [ 0, 1 ] }
end
