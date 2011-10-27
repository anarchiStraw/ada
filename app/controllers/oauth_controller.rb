class OauthController < ApplicationController
  skip_before_filter :require_login, :only => %w(verify_youroom callback_youroom)

  def verify_youroom
    request_token = youroom_consumer.get_request_token(:oauth_callback => callback_youroom_oauth_index_url())
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
  end

  def callback_youroom
    credentials = JSON.parse(access_token_as_youroom_user.get("#{Youroom.verify_credentials_url}.json").body)
    
    email = credentials["user"]["email"]
    @youroom_user = YouroomUser.find_by_email(email)
    if !@youroom_user
      logger.debug("new user.")
      @youroom_user = YouroomUser.new
      @youroom_user.email = email
    else
      logger.debug("user found.")
    end
    @youroom_user.access_token = access_token_as_youroom_user.token
    @youroom_user.access_token_secret = access_token_as_youroom_user.secret
    @youroom_user.save
    
    session[:youroom_user] = @youroom_user
    session[:rooms] = credentials["user"]["participations"].map{|item|
      [item["group"]["name"], item["group"]["id"]]
    }
    render "sessions/menu"
  end
  
  def verify_google
    request_token = google_consumer.get_request_token(
      {:oauth_callback => callback_google_oauth_index_url()}, :scope => Google.scope_calendar)
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
  end
  
  def callback_google
    calendars = JSON.parse(access_token_as_google_user.get(Google.all_calendars_url).body)
    @google_account = calendars["author"]["email"]
    render :text => @google_account
  end

end

