class Google
  def self.site
    "https://www.google.com"
  end
  
  def self.oauth_properties
    {
      :signature_method   => 'HMAC-SHA1',
      :site               => site,
      :request_token_path => '/accounts/OAuthGetRequestToken',
      :authorize_path     => '/accounts/OAuthAuthorizeToken',
      :access_token_path  => '/accounts/OAuthGetAccessToken',
    }
  end

  def self.scope_calendar
    "#{site}/calendar/feeds/"
  end
  
  def self.all_calendars_url
    "#{scope_calendar}/default/allcalendars/full?alt=jsonc"
  end
end
