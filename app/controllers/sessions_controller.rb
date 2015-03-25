class SessionsController < ApplicationController

	def new

	end

  def create

  	@user = User.find_by(username: params[:username])

  	if @user && @user.authenticate(params[:password])

      if @user.two_factor_auth?
        @user.generate_pin!
        session[:two_factor_auth] = true
        @user.send_pin_to_twilio
        redirect_to pin_path
      else
        login_success(@user.id)
      end
  	else
  	  flash[:error] = "Incorrect Username or Password" 
  	  render :new  		
  	end
		
	end

	def destroy
    session[:user_id] = nil
    session[:two_factor_auth] = nil
    flash[:notice] = "You have logged out"
    redirect_to root_path
	end

  def pin

    access_denied if session[:two_factor_auth].nil?
      
    if (request.post?)
      @user = User.find_by(pin: params[:pin])

      if @user
        @user.clear_pin!
        login_success(@user.id)
      else
        flash[:error] = "There is something wrong with your PIN."
        redirect_to pin_path
      end
    end
  end

  private

  def login_success(user_id)
    flash[:notice] = "Login successful"
    session[:user_id] = user_id
    session[:two_factor_auth] = nil
    redirect_to root_path
  end

end