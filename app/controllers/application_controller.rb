class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :https_redirect

  private

  def https_redirect
    if !request.ssl?
      flash.keep
      redirect_to protocol: "https://", status: :moved_permanently
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
end
