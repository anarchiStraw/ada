class GoogleCalendar
  attr_accessor :id, :title, :event_feed_link

  def self.events(oauth_access_token, google_calendar_id, start_min, duration)
    url = "#{google_calendar_id}?start-min=#{start_min.to_s}T00:00:00%2B09:00&start-max=#{(start_min + duration).to_s}T23:59:59%2B09:00&alt=jsonc"
p("url[" + url + "]")
    res = oauth_access_token.get(url)
    if res.body.match(/Moved Temporarily/)
      res = oauth_access_token.get(Nokogiri.HTML(res.body).at("//a")["href"])
    end
    items = JSON.parse(res.body)['data']['items']
    if items
      items.reject!{|item| (start_min.to_s != Date.strptime(item['when'][0]['start']).to_s) }
    end
    items
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