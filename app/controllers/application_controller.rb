# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  layout 'application'

  before_filter :detect_locale, :require_login

  helper_method :logged_in?, :participation_name

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def render_not_found
    logger.debug "headers: #{request.headers.map{ |k,v| "{#{k}:#{v}}"}.join(' ')}"
    respond_to do |format|
      format.html { render "public/404.html", :layout => false, :status => :not_found }
      format.all { head :not_found }
    end
  end

  private
  def detect_locale
    I18n.locale = request.headers['Accept-Language'].scan(/^[a-z]{2}/).first
  end
  
  def require_login
    if !logged_in?
      render "sessions/menu"
      return
    else
      @logged_in_as = session[:youroom_user].email
      return true
    end
  end

  def logged_in?
    !session[:youroom_user].blank?
  end

  def participation_name
    session[:participation_name] || ""
  end

  def youroom_consumer
    @youroom_consumer ||= OAuth::Consumer.new(configatron.youroom.consumer.key, configatron.youroom.consumer.secret, :site => 'http://youroom.in') #Youroom.root_url
  end

  def access_token_as_youroom_user
    @access_token_as_youroom_user ||=
      if session[:youroom_user]
        OAuth::AccessToken.new(youroom_consumer, session[:youroom_user].access_token, session[:youroom_user].access_token_secret)
      else
        request_token = OAuth::RequestToken.new(youroom_consumer, session[:request_token], session[:request_token_secret])
        request_token.get_access_token({}, :oauth_token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier])
      end
  end

  private
  def refresh_external_data
    calendars = []
    @google_accounts = GoogleAccount.find_all_by_youroom_user_id(session[:youroom_user].id)
    @google_accounts.each{|account|
      account.load_google_data
      account.calendars.each {|calendar|
        calendars.concat [[calendar.title, calendar.event_feed_link]]
      }
    }
    
    res = access_token_as_youroom_user.get("#{Youroom.my_groups_url}.json")
    rooms = JSON.parse(res.body).map {|item|
      [item["group"]["name"], item["group"]["id"]]
    }
    
    session[:google_accounts] = @google_accounts
    session[:calendars] = Hash[*calendars.flatten]
    session[:rooms] = Hash[*rooms.flatten]
  end
end
