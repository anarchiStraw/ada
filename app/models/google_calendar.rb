class GoogleCalendar
  attr_accessor :id, :title, :event_feed_link

  def self.events(oauth_access_token, google_calendar_id, start_min, duration, keyword)
    Time.zone = configatron.timezone
    from = Time.zone.local(start_min.year, start_min.month, start_min.day, 0, 0)
    to = Time.zone.local(start_min.year, start_min.month, start_min.day, 23, 59)
    
    url = "#{google_calendar_id}?start-min=#{Time.zone.local_to_utc(from).strftime("%Y-%m-%dT%H:%M:%SZ")}&start-max=#{Time.zone.local_to_utc(to).strftime("%Y-%m-%dT%H:%M:%SZ")}&alt=jsonc"
    url << "&q=#{URI.encode(keyword)}" unless keyword.nil?
    
p("url[" + url + "]")
    res = oauth_access_token.get(url)
    if res.body.match(/Moved Temporarily/)
      res = oauth_access_token.get(Nokogiri.HTML(res.body).at("//a")["href"])
    end
    
    if (res.class == Net::HTTPOK)
      items = JSON.parse(res.body)['data']['items']
      if items
        items.reject!{|item| (start_min.to_s != Date.strptime(item['when'][0]['start']).to_s) }
      end
      items
    else
      p JSON.parse(res.body)
      raise "FAILED to get events from Google calendar."
    end
  end

  def self.load items
    calendars = items.map{|item|
      if item['accessLevel'].match(/owner|editor|read/)
        GoogleCalendar.new(item['id'], item['title'], item['eventFeedLink'])
      end
    }
    calendars.reject{|calendar| calendar.nil? }
  end
  
  def initialize id, title, event_feed_link
    @id = id
    @title = title
    @event_feed_link = event_feed_link
  end
  
  def events access_token, condition
    res = access_token.get(@event_feed_link + condition)
  end
end