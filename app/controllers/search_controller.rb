class SearchController < ApplicationController
  def new
    search_term = search_params[:search].downcase
    @search_results = Post.where("lower(title) LIKE ? OR link LIKE ?",
                                 "%#{search_term}%",
                                 "%#{search_term}%").
                           order("created_at DESC").
                           paginate(page: params[:page], per_page: 30)
    if @search_results.empty?
      flash.now[:information] = "No results found"
    end

    @votes = Hash.new
    if logged_in?
      user_votes = Vote.where(user_id: current_user.id, comment_id: nil)

      user_votes.each do |vote|
        @votes[vote.post_id] = vote.vote
      end
    end
  end

  private

    def search_params
      params.require(:search).permit(:search)
    end
end
