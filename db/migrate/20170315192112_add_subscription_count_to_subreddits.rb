class AddSubscriptionCountToSubreddits < ActiveRecord::Migration[5.0]
  def change
    add_column :subreddits, :subscriptions_count, :integer, default: 0
    add_index  :subreddits, :subscriptions_count
  end
end
