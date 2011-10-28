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
    res = access_token_as_google_user.get(Google.all_calendars_url)

    if res.body.match(/Moved Temporarily/)
      res = access_token_as_google_user.get(Nokogiri.HTML(res.body).at("//a")["href"])
    end

    calendars = JSON.parse(res.body)['data']
    logger.debug(calendars.inspect)
    display_name = calendars['author']['displayName']
    email = calendars['author']['email']
    @google_account = GoogleAccounts.find_by_youroom_user_id_and_email(session[:youroom_user].id, email)
    if !@google_account
      @google_account = GoogleAccounts.new
      @google_account.youroom_user_id = session[:youroom_user].id
      @google_account.display_name = display_name
      @google_account.email = email
    end
    @google_account.access_token = access_token_as_google_user.token
    @google_account.access_token_secret = access_token_as_google_user.secret
    @google_account.save
    
    @msg = "以下のアカウントでGoogleカレンダーを参照します。"
    @google_accounts = GoogleAccounts.find_all_by_youroom_user_id(session[:youroom_user].id)
    @calendars = calendars

    render 'google_accounts/index'
  end

end

