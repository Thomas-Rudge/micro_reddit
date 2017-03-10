class PostsController < ApplicationController
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

      if @post.save
        redirect_to "/r/#{sub}/#{@post.id}"
      else
        render :new
      end
    else
      @post.errors.add(:sub, "Unknown subreddit #{sub}")
      render :new
    end
  end

  private

    def referring_subreddit(referer)
      num = referer =~ /\/r\/*/

      referer = num.nil? ? "" : referer[num+3..-1]
    end

    def post_params
      params.require(:post).permit(:link,
                                   :title,
                                   :post_text)
    end

    def post_type(link)
      # 1 = link post, 0 = text post
      link.blank? ? 0 : 1
    end
end
