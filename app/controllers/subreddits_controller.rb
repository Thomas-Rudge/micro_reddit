class SubredditsController < ApplicationController

  def index
    @subreddits = Subreddit.order("subscriptions_count DESC").all.
                            paginate(page: params[:page], per_page: 30)
    @subscriptions = Subscription.where(user_id: current_user.id).
                                  pluck(:subreddit_id) rescue nil
  end

  def new
    @subreddit = Subreddit.new
  end

  def create
    @subreddit = Subreddit.new(sub_params)
    @subreddit.mod = current_user.id if logged_in?

    if @subreddit.save
      flash[:information] = "Subreddit successfully created!"
      current_user.subreddits << @subreddit

      redirect_to "/r/#{@subreddit.name}"
    else
      render :new
    end
  end

  def show
    @subreddit = Subreddit.find_by(name: params[:name])
    if @subreddit.nil?
      flash.now[:information] = "r/#{params[:name]} doesn't exist.\nWhy don't you create it?"
      @posts = []
    else
      @posts = @subreddit.posts.where("upvotes - downvotes > -10").
                                paginate(page: params[:page], per_page: 30)

      @votes = Hash.new
      if logged_in?
        user_votes = Vote.where(user_id: current_user.id, comment_id: nil)

        user_votes.each do |vote|
          @votes[vote.post_id] = vote.vote
        end
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

    def sub_params
      params.require(:subreddit).permit(:name,
                                        :description,
                                        :sidebar,
                                        :nsfw)
    end
end
