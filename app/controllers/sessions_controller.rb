class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:username], params[:password])
    if user
      session[:user_id] = user.id
      create_cart
      redirect_to user_dashboard_path, notice: "Logged in!"
    else
      redirect_to login_path, :flash => { :error => "Username and/or password invalid!" }
    end
  end

  def destroy
    session[:user_id] = nil
    destroy_cart
    redirect_to home_path, notice: "Logged out!"
  end
end
