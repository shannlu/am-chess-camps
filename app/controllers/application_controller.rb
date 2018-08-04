class ApplicationController < ActionController::Base
  include AppHelpers::Cart

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not authorized to take this action."
    redirect_back(fallback_location: home_path)
  end

  # handle 404 errors with an exception as well
  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:error] = "Record not found."
    redirect_to home_path
  end


  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_user_name
    if current_user.role == "parent"
      @current_user_name = Family.where(user_id: current_user.id).first.parent_name
    else
      @current_user_name = "Admin"
    end
  end
  helper_method :current_user_name

  def logged_in?
    current_user
  end
  helper_method :logged_in?

  def check_login
    redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end
end
