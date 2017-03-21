module FrontPagesHelper
  def current_users_subreddits
    @mysubreddits ||= Subscription.where(user_id: current_user.id).
                                   includes(:subreddit).
                                   pluck(:name).sort
  end

  def current_popular_subreddits
    @popular_subreddits ||= Subreddit.order(:subscriptions_count).
                                         limit(30).
                                         pluck(:name)
  end
end
