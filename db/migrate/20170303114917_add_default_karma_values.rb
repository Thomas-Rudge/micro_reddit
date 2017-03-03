class AddDefaultKarmaValues < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users,    :comment_karma, 0
    change_column_default :users,    :post_karma,    0
    change_column_default :posts,    :upvotes,       0
    change_column_default :posts,    :downvotes,     0
    change_column_default :comments, :upvotes,       0
    change_column_default :comments, :downvotes,     0
  end
end
