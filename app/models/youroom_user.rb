class YouroomUser < ActiveRecord::Base
  has_many :notice_settings
  has_many :google_accounts
  
  def post room_number, entry_hash
p enry_hash
    res = oauth_access_token.post(Youroom.post_url(room_number), entry_hash)
p res.body
    res.body
  end

  def oauth_access_token
    @oauth_access_token ||= OAuth::AccessToken.new(Youroom.consumer, self.access_token, self.access_token_secret)
  end
end
