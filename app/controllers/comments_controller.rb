class CommentsController < ApplicationController
  before_action :check_login_status

  def create
    return if params[:comment][:content].blank?

    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.post_id = params[:post_id]
    @comment.upvotes = 1

    if @comment.save
      Vote.new(user_id: current_user.id,
               post_id: params[:post_id],
               comment_id: @comment.id,
               vote: 1).save

      User.find(current_user.id).increment!(:comment_karma)

      redirect_to :back
    end
  end

  def check_login_status
    head 403 unless logged_in?
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end
end
