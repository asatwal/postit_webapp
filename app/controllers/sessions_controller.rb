class SessionsController < ApplicationController

	def new

	end

  def create

  	@user = User.find_by(username: params[:username])

  	if @user && @user.authenticate(params[:password])
  		flash[:notice] = "Login successful"
  		session[:user_id] = @user.id
  		redirect_to root_path
  	else
  	  flash[:error] = "Incorrect Username or Password" 
  	  render :new  		
  	end
		
	end

	def destroy
    session[:user_id] = nil
    flash[:notice] = "You have logged out"
    redirect_to root_path
	end

end