class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_login, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]

  def show

  end

  def edit
    
  end

  def update
    
    if @user.update(user_params)
      flash[:notice] = "User updated"
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

	def new
		@user = User.new
	end

	def create

    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "New user #{@user.username} created"

      # Save user to session as this indicates user logged in
      session[:user_id] = @user.id

      redirect_to posts_path
    else
      render :new
    end

  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :time_zone)
  end

  def set_user
    @user = User.find_by slug: params[:id]
  end

  def require_same_user
    if (@user != current_user)
      flash[:error] = "You are now allowed to perform that action for User #{@user.username}"
      redirect_to user_path(@user)
    end
  end

end