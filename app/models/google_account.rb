class GoogleAccount < ActiveRecord::Base
  belongs_to :youroom_user
  
  def load_google_data
      res = oauth_access_token.get(Google.all_calendars_url)

    if res.body.match(/Moved Temporarily/)
      res = oauth_access_token.get(Nokogiri.HTML(res.body).at("//a")["href"])
    end

    data = JSON.parse(res.body)['data']
    self.display_name = data['author']['displayName']
    self.email = data['author']['email']
    self.calendars = GoogleCalendar.load(data['items'])
  end
  
  def calendars
    read_attribute(:calendars)
  end
  
  def calendars=(v)
    write_attribute(:calendars, v)
  end
  
  
  def same_account?
    GoogleAccount.find_by_youroom_user_id_and_email(self.youroom_user_id, self.email)
  end

  def oauth_access_token
logger.debug ('GoogleAccount.oauth_access_token-----------------')
logger.debug (Google.consumer.to_s)
logger.debug (self.access_token)
logger.debug (self.access_token_secret)
    @oauth_access_token ||= OAuth::AccessToken.new(Google.consumer, self.access_token, self.access_token_secret)
  end
end