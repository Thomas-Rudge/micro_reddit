class AddKarmaToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :karma,         :integer
    add_column :users, :comment_karma, :integer
    add_column :users, :post_karma,    :integer
  end
end
