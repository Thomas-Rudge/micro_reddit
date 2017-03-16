class PostsController < ApplicationController
  TEXTPOST_THUMBNAIL = "http://i.imgur.com/vKvm5pe.jpg"

  def new
    @post = Post.new
    @referer = referring_subreddit(request.headers["HTTP_REFERER"])
  end

  def create
    @post  = Post.new(post_params)
    sub    = params[:post][:sub].downcase
    sub_id = subreddit_id(sub)
    if sub
      @post.subreddit_id = sub_id
      @post.user_id      = current_user.id
      @post.post_type    = post_type(params[:post][:link])
      @post.thumbnail    = TEXTPOST_THUMBNAIL if @post.post_type == 0
      @post.upvotes      = 1

      if @post.save
        Vote.new(user_id: current_user.id, post_id: @post.id, vote: 1).save
        User.find(current_user.id).increment!(:post_karma)

        redirect_to "/r/#{sub}/#{@post.id}"
      else
        render :new
      end
    else
      @post.errors.add(:sub, "Unknown subreddit #{sub}")
      render :new
    end
  end

  def show
    @post = Post.find(params[:id]) rescue nil
    @subreddit = Subreddit.find_by(name: params[:subreddit_name])

    if @post.nil? || @subreddit.nil?
      flash.now[:information] = "If this post existed, it doesn't anymore. Sorry ¯\\_(ツ)_/¯"
    else
      @comments = @post.comments.order("upvotes DESC").includes(:user)
                                .paginate(page: params[:page], per_page: 30)

      @comments_votes = Hash.new
      @votes          = Hash.new
      if logged_in?
        post_votes = @post.votes.where(user_id: current_user.id, comment_id: nil)
        comm_votes = @post.votes.where(user_id: current_user.id).where.not(comment_id: nil)


        post_votes.each do |vote|
          @votes[vote.post_id] = vote.vote
        end

        comm_votes.each do |vote|
          @comments_votes[vote.comment_id] = vote.vote
        end
      end
    end
  end

  private

    def post_params
      params.require(:post).permit(:link,
                                   :title,
                                   :post_text,
                                   :thumbnail)
    end
end
