# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'youroom'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  layout 'application'

  before_filter :require_login

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
  def require_login
    if !logged_in?
      render "sessions/login_required"
      return
    else
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

  def google_consumer
#    @google_consumer ||= OAuth::Consumer.new(
#      configatron.google.consumer.key, configatron.google.consumer.secret, Google.oauth_properties)
logger.debug("configatron.youroom.consumer.key " + configatron.youroom.consumer.key.to_s + " "+ configatron.youroom.consumer.secret.to_s)
logger.debug("configatron.google.consumer.key " + configatron.google.consumer.key.to_s + " "+ configatron.google.consumer.secret.to_s)
logger.debug(Google.oauth_properties.inspect)
@google_consumer = OAuth::Consumer.new 'attentive-ada.heroku.com', 'OMNik85prDu9gCNvWakEF4F6', Google.oauth_properties
  end

  def access_token_as_google_user
    @access_token_as_google_user ||=
      if session[:google_user]
        OAuth::AccessToken.new(google_consumer, session[:google_user].access_token, session[:google_user].access_token_secret)
      else
        request_token = OAuth::RequestToken.new(google_consumer, session[:request_token], session[:request_token_secret])
        request_token.get_access_token({}, :oauth_token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier])
      end
  end

end
