class PostsController < ApplicationController
  def new
    @post = Post.new
    @referer = referring_subreddit(request.headers["HTTP_REFERER"])
  end

  private

    def referring_subreddit(referer)
      num = referer =~ /\/r\/*/

      referer = num.nil? ? "" : referer[num+3..-1]
    end
end
