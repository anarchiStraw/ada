#coding:utf-8
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
    debugger
    rooms = credentials["user"]["participations"].map{|item|
      [item["group"]["name"], item["group"]["id"]]
    }
    session[:rooms] = Hash[*rooms.flatten]
    render "sessions/menu"
  end
  
  def verify_google
    request_token = Google.consumer.get_request_token(
      {:oauth_callback => callback_google_oauth_index_url()}, :scope => Google.scope_calendar)
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
  end
  
  def callback_google
    
    request_token = OAuth::RequestToken.new(Google.consumer, session[:request_token], session[:request_token_secret])
    access_token = request_token.get_access_token({}, :oauth_token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier])
    @google_account = GoogleAccount.new()
    @google_account.youroom_user_id = session[:youroom_user].id
    @google_account.access_token = access_token.token
    @google_account.access_token_secret = access_token.secret
    @google_account.load_google_data
    calendars = @google_account.calendars.map {|calendar|
      [calendar.title, calendar.event_feed_link]
    }
    session[:calendars] = Hash[*calendars]

    if old = @google_account.same_account?
      old.access_token = @google_account.access_token
      old.access_token_secret = @google_account.access_token_secret
      old.save
    else
      @google_account.save
    end
    
    @msg = "以下のアカウントでGoogleカレンダーを参照します。"
    @google_accounts = GoogleAccount.find_all_by_youroom_user_id(session[:youroom_user].id)
    render 'google_accounts/index'
  end

end

