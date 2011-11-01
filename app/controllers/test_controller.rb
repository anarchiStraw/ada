class TestController < ApplicationController
  skip_before_filter :require_login
  
  load 'youroom.rb'
  load 'google.rb'
  load 'google_account.rb'
  
  def create_youroom_user
    a = GoogleAccount.find(1)
    render :text => a.email + " " + a.access_token_secret
  end

end

