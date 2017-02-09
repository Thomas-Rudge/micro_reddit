class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string     :title
      t.text       :link
      t.text       :post_text
      t.integer    :post_type
      t.belongs_to :user,      index: true
      t.belongs_to :subreddit, index: true

      t.timestamps
    end
  end
end
