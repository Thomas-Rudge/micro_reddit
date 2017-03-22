class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if (Rails.env.development? && @user.save) ||
       (verify_recaptcha(model: @user) && @user.save)
      log_in @user
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @user = User.find_by(name: params["name"])

    if @user.nil?
      flash.now[:danger] = "Could not find user #{params["name"]}"
      @user_collection = Array.new
    else
      posts    = @user.posts
      comments = @user.comments
      @user_collection = (posts + comments).sort! { |a,b| b.created_at <=> a.created_at }
      @user_collection.paginate(page: params[:page], per_page: 30)

      @comments_votes = Hash.new
      @votes          = Hash.new
      if logged_in?
        all_votes = @user.votes

        all_votes.each do |vote|
          if vote.comment_id.nil?
            @votes[vote.post_id] = vote.vote
          else
            @comments_votes[vote.comment_id] = vote.vote
          end
        end
      end
    end
  end

  def delete
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                   :password,
                                   :password_confirmation)
    end
end
