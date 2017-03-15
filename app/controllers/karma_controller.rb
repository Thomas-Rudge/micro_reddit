class KarmaController < ApplicationController
  before_action :check_login_status

  def update
    @ok_params = params.permit(:id, :type, :karma, :postid)

    head 403 if bad_params?

    case @ok_params[:karma].to_i
    when 1  then upvote
    when 0  then remove_vote
    when -1 then downvote
    end

    head 202
  end

  def check_login_status
    head 403 unless logged_in?
  end

  private

    def upvote
      if @ok_params[:type] == "post"
        vote = Vote.new(user_id: current_user.id, post_id: @ok_params[:id].to_i, vote: 1)
        vote_target = Post.find(@ok_params[:id].to_i)
      else
        vote = Vote.new(user_id: current_user.id, post_id: @ok_params[:postid].to_i,
                        comment_id: @ok_params[:id].to_i, vote: 1)
        vote_target = Comment.find(@ok_params[:id].to_i)
      end

      unless vote_target.nil?
        vote_target.increment(:upvotes)
        vote_target.save rescue nil
        vote.save        rescue nil
      end
    end

    def downvote
      if params[:type] == "post"
        vote = Vote.new(user_id: current_user.id, post_id: @ok_params[:id].to_i, vote: 0)
        vote_target = Post.find(@ok_params[:id].to_i)
      else
        vote = Vote.new(user_id: current_user.id, post_id: @ok_params[:postid].to_i,
                        comment_id: @ok_params[:id].to_i, vote: 0)
        vote_target = Comment.find(@ok_params[:id].to_i)
      end

      unless vote_target.nil? || vote.nil?
        vote_target.increment(:downvotes)
        vote_target.save rescue nil
        vote.save        rescue nil
      end
    end

    def remove_vote
      if params[:type] == "post"
        vote = Vote.find_by(user_id: current_user.id, post_id: @ok_params[:id].to_i, comment_id: nil)
        vote_target = Post.find(@ok_params[:id].to_i)
      else
        vote = Vote.find_by(user_id: current_user.id, post_id: @ok_params[:postid].to_i,
                            comment_id: @ok_params[:id].to_i)
        vote_target = Comment.find(@ok_params[:id].to_i)
      end

      unless vote_target.nil? || vote.nil?
        case vote.vote
        when 0 then vote_target.decrement(:downvotes)
        when 1 then vote_target.decrement(:upvotes)
        end

        vote_target.save
      end

      vote.destroy rescue nil
    end

    def bad_params?
      if @ok_params[:id].to_i.to_s != @ok_params[:id]
        false
      elsif @ok_params[:postid].to_i.to_s != @ok_params[:postid]
        false
      elsif ![-1, 0, 1].include? @ok_params[:karma]
        false
      elsif !["comment", "post"].include? @ok_params[:type]
        false
      else
        true
      end
    end
end
