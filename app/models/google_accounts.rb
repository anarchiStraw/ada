load 'google_calendar.rb'
load 'google.rb'

class GoogleAccounts < ActiveRecord::Base
  def load_calendars google_consumer
    access_token = OAuth::AccessToken.new(google_consumer, @access_token, @access_token_secret)
    
    @calendars = GoogleCalendar.all(access_token)
  end
  
  def calendars
    @calendars
  end
end
