#coding:utf-8
require "time"

class Notice
  def self.post(today_is = Time.now.strftime("%Y/%m/%d"))
    consumer = Google.consumer
    settings = NoticeSetting.all
    settings.each do |setting| 
      google_account = GoogleAccount.find(setting[:google_account_id])
      events = GoogleCalendar.events(
        google_account.oauth_access_token, 
        setting[:google_calendar_id], 
        Date.strptime(today_is, "%Y/%m/%d") + setting[:days_before].to_i,
        0
      )
      if events 
        logger.info("Found #{events.size} events for NoticeSetting[#{setting.id}]. ")
      else
        logger.info("No event was found for NoticeSetting[#{setting.id}].)
      end
      youroom_user = YouroomUser.find(setting[:youroom_user_id])
      events.each do |event|
        youroom_user.post(
          setting[:room_number], 
          format_message(event, setting[:additional_message].to_s)
        )
      end
    end
  end
  
  def self.test(setting, today_is = Time.now.strftime("%Y/%m/%d"))
    consumer = Google.consumer
    google_account = GoogleAccount.find(setting[:google_account_id])
    the_day = Date.strptime(today_is, "%Y/%m/%d") + 1 # 明日から
    samples = []
    3.times {|i|
      events = GoogleCalendar.events(
        google_account.oauth_access_token, 
        setting[:google_calendar_id], 
        the_day + i + setting[:days_before].to_i,
        0
      )
      if events
        events.each {|event|
         samples << { (the_day + i).to_s => format_message(event, setting[:additional_message])} # Dateのまま入れて、ビューで整形したい
        }
      end
    }
    samples
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
    Time.zone = configatron.timezone
p ("from_str=" + from_str + " timezone=" + Time.zone.to_s + " from=" + Time.zone.parse(from_str).to_s)
    from = Time.zone.parse(from_str)
    to = Time.zone.parse(to_str)
    
    str = from.strftime("%Y/%m/%d")
    str << from.strftime(" %H:%M - ") if (0 < (to - from))
    str << to.strftime("%Y/")         if (to.year != from.year)
    str << to.strftime("%m/%d ")       if (to.year != from.year) || (to.strftime("%m/%d") != from.strftime("%m/%d"))
    str << to.strftime("%H:%M")      if (0 < (to - from))
    
    return str
  end
end