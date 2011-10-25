class SessionsController < ApplicationController
  skip_before_filter :require_login

  def destroy
    reset_session
    redirect_to root_url
  end
end
