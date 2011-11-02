#coding:utf-8
require "time"

class Notice
  def self.post(today_is = Time.now.strftime("%Y/%m/%d"))
    consumer = Google.consumer
    settings = NoticeSetting.all
    settings.each {|setting|
      google_account = GoogleAccount.find(setting[:google_account_id])
      events = GoogleCalendar.events(
        google_account.oauth_access_token, 
        setting[:google_calendar_id], 
        Date.strptime(today_is, "%Y/%m/%d") + setting[:days_before].to_i,
        0
      )
      youroom_user = YouroomUser.find(setting[:youroom_user_id])
      events.each {|event|
        debugger
        youroom_user.post(
          setting[:room_number], 
          format_message(event, setting[:additional_message].to_s)
        )
      }
    }
  end
  
  def self.test setting
    consumer = Google.consumer
    google_account = GoogleAccount.find(setting[:google_account_id])
    the_day = Date.strptime(Time.now, "%Y/%m/%d") + setting[:days_before].to_i
    (0..20).map {|i|
      events = GoogleCalendar.events(
        google_account.oauth_access_token, 
        setting[:google_calendar_id], 
        the_day + i + setting[:days_before].to_i,
        0
      )
      [ (the_day + i).sprintf("%Y/%m/%d"), events.each {|event| format_message(event, setting[:additional_message])}]
    }
  end
  
  private
  def self.format_message(event, additional_message)
    str = ''
    str << additional_message
    str << " " + event['title']
    str << " " + duration(event['when'][0]['start'], event['when'][0]['end'])
    str << (" ＠" + event['location']) if (event['location'] != '')
    str << " " + event['details']

    {
      'entry[content]' => str[0..Youroom.message_max_length],
      'entry[attachment_attributes][data][text]' => str[Youroom.message_max_length + 1].to_s + event['alternateLink'],
      'entry[attachment_attributes][attachment_type]' => 'Text'
    }
  end
  
  def self.duration(from_str, to_str)
    from = Time.parse(from_str)
    to = Time.parse(to_str)
    
    str = from.strftime("%Y/%m/%d")
    str << from.strftime(" %H:%M - ") if (0 < (to - from))
    str << to.strftime("%Y/")         if (to.year != from.year)
    str << to.strftime("%m/%d ")       if (to.year != from.year) || (to.strftime("%m/%d") != from.strftime("%m/%d"))
    str << to.strftime("%H:%M")      if (0 < (to - from))
    
    return str
  end
end