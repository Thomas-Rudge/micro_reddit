class AddSidebarToSubreddits < ActiveRecord::Migration[5.0]
  def change
    add_column :subreddits, :sidebar, :text
  end
end
