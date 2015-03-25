class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_login, except: [:index, :show] 
  before_action :require_creator, only: [:edit, :update] 

  def index
    @posts = Post.all.sort_by{|post| post.total_votes}.reverse

    respond_to do |format|

      format.html

      format.xml {render xml: @posts}

      format.json {render json: @posts}

    end

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
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(creator: current_user, voteable: @post, vote: params[:vote])

    respond_to do |format|

      format.html do

       if @vote.valid?
         flash[:notice] = "Your vote was counted"
       else
        flash[:error] = "You are only allowed to vote on that post once"
       end

        redirect_to :back
      end

      format.js

    end
    
  end

  private

  def set_post
    @post = Post.find_by slug: params[:id]
  end

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def require_creator
    access_denied unless logged_in? && (current_user.admin? || current_user == @post.creator)
  end

end
