class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, dependent: :destroy

  validates :content, length: { in: 1..1_000 }
end
