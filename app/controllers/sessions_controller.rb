class SessionsController < ApplicationController
  
  def menu
    @youroom_user ||= session[:youroom_user]
  end

  def destroy
    reset_session
    redirect_to root_url
  end
end
