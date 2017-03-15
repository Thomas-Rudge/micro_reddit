class Comment < ApplicationRecord
  has_many :votes, dependent: :destroy
  belongs_to :user
  belongs_to :post

  validates :content, length: { in: 1..1_000 }

  def karma
    self.upvotes - self.downvotes
  end
end
