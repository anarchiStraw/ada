class OauthController < ApplicationController
  skip_before_filter :require_login, :only => %w(verify_youroom callback_youroom)

  def verify_youroom
    request_token = youroom_consumer.get_request_token(:oauth_callback => callback_youroom_oauth_index_url())
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
  end

  def callback_youroom
    if authorize?
       render :text => 'ok'
#      redirect_to notices_url()
    else
       render :text => 'ng'
#      render_not_found
    end
  end

  def verify_twitter
    request_token = twitter_consumer.get_request_token(:oauth_callback => callback_twitter_oauth_index_url())
    session[:twitter_request_token] = request_token.token
    session[:twitter_request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
  end

end

