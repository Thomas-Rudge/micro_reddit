class AddCommentcountToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :comment_count, :integer, default: 0
  end
end
