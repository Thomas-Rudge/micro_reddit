class SubscriptionsController < ApplicationController
  def create
    permit = params.permit(:id)
    sub = Subreddit.find(permit[:id]) rescue nil

    unless sub.nil?
      current_user.subreddits << sub
      head 202
    end
  end

  def destroy
    permit = params.permit(:id)
    current_user.subscriptions.find_by(subreddit_id: permit[:id]).destroy() rescue nil
    head 202
  end
end
