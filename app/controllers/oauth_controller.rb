class OauthController < ApplicationController
  skip_before_filter :require_login, :only => %w(verify_youroom callback_youroom)

  def verify_youroom
    request_token = youroom_consumer.get_request_token(:oauth_callback => callback_youroom_oauth_index_url())
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
  end

  def callback_youroom
    @youroom_user = YouroomUser.find_by_access_token_and_access_token_secret(access_token_as_youroom_user.token, access_token_as_youroom_user.secret)
    if !@youroom_user
      @youroom_user = YouroomUser.new
      @youroom_user.access_token = access_token_as_youroom_user.token
      @youroom_user.access_token_secret = access_token_as_youroom_user.secret
      @youroom_user.save
    end
    
    session[:youroom_user] = @youroom_user
    render "sessions/menu"
  end
  
  def new_google_access_token
  
  end
  
  def create_google_access_token
  
  end
  
  def callback_google
  
  end

end

