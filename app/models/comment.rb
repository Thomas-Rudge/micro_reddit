class Comment < ApplicationRecord
  has_many :votes
  belongs_to :user
  belongs_to :post, dependent: :destroy

  validates :content, length: { in: 1..1_000 }

  def karma
    self.upvotes - self.downvotes
  end
end
