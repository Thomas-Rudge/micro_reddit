class SubredditsController < ApplicationController

  def index
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
