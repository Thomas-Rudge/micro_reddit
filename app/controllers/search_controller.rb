class SearchController < ApplicationController
  def new
    # TODO// use Ajax in view to handle empty search strings
    search_term = params[:search][:search].downcase

    @search_results = Post.where("lower(title) LIKE ? OR link LIKE ?",
                                 "%#{search_term}%",
                                 "%#{search_term}%").
                           order("created_at DESC").
                           paginate(page: params[:page], per_page: 30)

    if @search_results.empty?
      flash.now[:information] = "No results found for: #{search_term}"
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
