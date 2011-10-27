class SessionsController < ApplicationController
  skip_before_filter :require_login
  
  def menu
    @youroom_user ||= session[:youroom_user]
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
