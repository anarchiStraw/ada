#coding:utf-8

require "time"

class Notice
  def self.post(today_is = nil)

    Time.zone = configatron.timezone
    today_is ||= Time.zone.now.strftime("%Y/%m/%d")

    consumer = Google.consumer
    settings = NoticeSetting.all
    settings.each do |setting| 
      begin
        google_account = GoogleAccount.find(setting[:google_account_id])
        events = GoogleCalendar.events(
          google_account.oauth_access_token, 
          setting[:google_calendar_id], 
          Date.strptime(today_is, "%Y/%m/%d") + setting[:days_before].to_i,
          0,
          setting[:use_keyword] ? setting[:keyword] : nil
        )
        if events 
          p ("Found #{events.size} events for NoticeSetting[#{setting.id}]. ")
          youroom_user = YouroomUser.find(setting[:youroom_user_id])
          events.each do |event|
            youroom_user.post(
              setting[:room_number], 
              format_message(event, setting[:additional_message].to_s)
            )
            p ("Posted a message for NoticeSetting[#{setting.id}].")
          end
        else
          p("No event was found for NoticeSetting[#{setting.id}].")
        end
      rescue => e
        p("An ERROR occured while processing NoticeSetting[#{setting.id}].")
        p(e.message)
        YouroomUser.find(
          configatron.admin.youroom.user_id).post(
            configatron.admin.youroom.room_number,
            {'entry[content]'  => 'An error occured in Notice#post. Check the log.'})
        next
      end
    end
  end
  
  def self.test_all(today_is = Time.now.strftime("%Y/%m/%d"))
    NoticeSetting.all.each do |setting|
      p test(setting, today_is)
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
        0,
        setting[:use_keyword] ? setting[:keyword] : nil
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
    str << additional_message if (additional_message.to_s != '')
    str << " " + event['title'] if (event['title'].to_s != '')
    str << " " + duration(event['when'][0]['start'], event['when'][0]['end']) if (event['when'].to_s != '')
    str << (" ＠" + event['location']) if (event['location'].to_s != '')
    str << " " + event['details'] if (event['details'].to_s != '')

      debugger
    
    index_before_url = str.length
    
    str << " " + ShortUrl.get(event['alternateLink']) if (event['alternateLink'].to_s != '')
    
    if str.length < Youroom.message_max_length then
      {
        'entry[content]' => str
      }
    else
      str_more = '...'
      split_at = [(Youroom.message_max_length - str_more.length), index_before_url].min
      {
        'entry[content]'  => str[0..split_at] + str_more,
        'entry[attachment_attributes][data][text]' => str[split_at + 1 .. -1],
        'entry[attachment_attributes][attachment_type]' => 'Text'
      }
    end
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