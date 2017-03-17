class VotesController < ApplicationController
  before_action { head 403 unless logged_in? }

  def update
    @ok_params = params.permit(:id, :type, :karma, :postid)
    @karma = @ok_params[:karma].to_i
    @ok_params[:id] = @ok_params[:id].blank? ? nil : @ok_params[:id]

    head 403 if bad_params?

    case @karma
    when 2  then upvote
    when 1  then upvote
    when 0  then remove_vote
    when -1 then downvote
    when -2 then downvote
    end

    head 202
  end

  private

    def upvote
      vote_subject = find_vote_subject
      return if vote_subject.nil?

      vote = find_or_generate_vote
      vote.vote = 1

      if vote.save
        @karma.times { vote_subject.increment!(:upvotes) }
        update_user_karma(vote_subject.user_id)
      end
    end

    def downvote
      vote_subject = find_vote_subject
      return if vote_subject.nil?

      vote = find_or_generate_vote
      vote.vote = 0

      if vote.save
        @karma.abs.times { vote_subject.increment!(:downvotes) }
        update_user_karma(vote_subject.user_id)
      end
    end

    def remove_vote
      vote_subject = find_vote_subject
      return if vote_subject.nil?

      vote = find_or_generate_vote

      case vote.vote
      when 0 then vote_subject.decrement!(:downvotes)
      when 1 then vote_subject.decrement!(:upvotes)
      end

      @karma = vote.vote == 0 ? 1 : -1
      update_user_karma(vote_subject.user_id)

      vote.destroy rescue nil
    end

    def update_user_karma(user_id)
      user = User.find(user_id) rescue nil
      return if user.nil?

      attribute = @ok_params[:type] == "post" ? :post_karma : :comment_karma

      if @karma > 0
        @karma.times { user.increment!(attribute) }
      else
        @karma.abs.times { user.decrement!(attribute) }
      end
    end

    def bad_params?
      if !@ok_params[:id].blank? || @ok_params[:id].to_i.to_s != @ok_params[:id]
        false
      elsif @ok_params[:postid].to_i.to_s != @ok_params[:postid]
        false
      elsif ![-2, -1, 0, 1, 2].include? @ok_params[:karma]
        false
      elsif !["comment", "post"].include? @ok_params[:type]
        false
      else
        true
      end
    end

    def find_vote_subject
      if @ok_params[:id].blank?
        Post.find(@ok_params[:postid])
      else
        Comment.find(@ok_params[:id])
      end
    end

    def find_or_generate_vote
      vote = Vote.find_by(user_id: current_user.id,
                          post_id: @ok_params[:postid],
                          comment_id: @ok_params[:id])

      unless vote
        vote = Vote.new(user_id: current_user.id,
                        post_id: @ok_params[:postid],
                        comment_id: @ok_params[:id])
      end

      vote
    end
end
