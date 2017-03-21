class FrontPagesController < ApplicationController
  def index
    if logged_in?
      subs  = Subscription.where(user_id: current_user.id).
                           pluck(:subreddit_id).map(&:to_i)

      @posts = Post.where(subreddit_id: subs).
                          includes(:subreddit, :user).
                          order("upvotes DESC").
                          paginate(page: params[:page], per_page: 30)
    else
      @posts = Post.includes(:subreddit, :user).
                    order("upvotes DESC").
                    paginate(page: params[:page], per_page: 30)
    end

    @votes = Hash.new
    if logged_in?
      user_votes = Vote.where(user_id: current_user.id, comment_id: nil)

      user_votes.each do |vote|
        @votes[vote.post_id] = vote.vote
      end
    end
  end
end
