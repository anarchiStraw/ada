class TestController < ApplicationController
  skip_before_filter :require_login
  
  load 'youroom.rb'
  load 'google.rb'
  
  def create_youroom_user
#    credentials = JSON.parse(access_token_as_youroom_user.get("#{Youroom.verify_credentials_url}.json").body)
    
#    email = credentials["user"]["email"]
#    render :text => credentials["user"]["participations"].map{|item|
#      [item["group"]["name"], item["group"]["id"]]
#    }.inspect
     render :text => "aaaa"
  end

end

