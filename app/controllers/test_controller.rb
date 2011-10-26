class TestController < ApplicationController
  skip_before_filter :require_login

  def create_youroom_user
    res = access_token_as_youroom_user.get("#{Youroom.my_groups_url}.json")
    @groups = JSON.parse(res.body).map {|item|
      {item["group"]["id"] => item["group"]["name"]}
    }
    render :text => @groups.inspect
    
  end

end

