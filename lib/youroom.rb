class Youroom
  def self.consumer
    @@consumer ||= OAuth::Consumer.new(configatron.youroomn.consumer.key, configatron.youroom.consumer.secret, :site => "#{root_url}")
  end

  def self.root_url
     "http://www.youroom.in"
#    "http://#{configatron.youroom_url_options[:host]}:#{configatron.youroom_url_options[:port]}"
  end

  def self.group_url group_id
    "#{scheme}://www.#{configatron.youroom_url_options[:host]}:#{configatron.youroom_url_options[:port]}/r/#{group_id}"
  end

  def self.my_groups_url
#    "#{scheme}://www.#{configatron.youroom_url_options[:host]}:#{configatron.youroom_url_options[:port]}/groups/my"
    "https://www.#{configatron.youroom_url_options[:host]}/groups/my"
  end

  def self.verify_credentials_url
    "https://www.#{configatron.youroom_url_options[:host]}/verify_credentials"
  end
  
  def self.post_url group_id
    "https://www.youroom.in/r/#{group_id}/entries.json"
  end

  def self.scheme
    if %w(production staging).include? ::Rails.env
      "https"
    else
      "http"
    end
  end
  
  def self.message_max_length
    280
  end
end
