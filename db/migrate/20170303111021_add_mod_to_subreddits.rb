class AddModToSubreddits < ActiveRecord::Migration[5.0]
  def change
    add_column :subreddits, :mod, :integer
  end
end
