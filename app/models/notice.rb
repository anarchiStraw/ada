class Notice < ActiveRecord::Base
  def test
    post(@self.calender_url, @self.youroom_access_key, @self.youroom_access_key_secret, @self.room_id, @self.message)
  end
  
end
