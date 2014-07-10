class CommentsController < ApplicationController

  before_action :require_login
  before_action :set_comment, only: :vote

  def create

    @post = Post.find(params[:post_id])

    @comment = @post.comments.new(comment_params)

    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "New comment created"

      redirect_to post_path(@post)
    else
      render 'posts/show'
    end

  end

  def vote
    @vote = Vote.new(creator: current_user, voteable: @comment, vote: params[:vote])

    if @vote.save
     flash[:notice] = "Your vote was counted"
    else
     flash[:error] = "You are only allowed to vote on that comment once"
    end

    redirect_to :back
  end


  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

end