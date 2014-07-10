class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_login, except: [:index, :show] 

  def index
  	@posts = Post.all.sort_by{|post| post.total_votes}.reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create

    @user = current_user

    @post = @user.posts.new(post_params)

    if @post.save
      flash[:notice] = "New post created"

      redirect_to posts_path
    else
      render :new
    end

  end

  def edit
  end

  def update

    if @post.update(post_params)
      flash[:notice] = "Post updated"
      redirect_to post_path
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.new(creator: current_user, voteable: @post, vote: params[:vote])

    if @vote.save
     flash[:notice] = "Your vote was counted"
    else
     flash[:error] = "You are only allowed to vote on that post once"
    end

    redirect_to :back
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

end
