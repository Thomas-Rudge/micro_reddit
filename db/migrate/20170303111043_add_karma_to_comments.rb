class AddKarmaToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :upvotes,   :integer
    add_column :comments, :downvotes, :integer
  end
end
