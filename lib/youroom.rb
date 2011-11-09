class Youroom
  def self.consumer
    @@consumer ||= OAuth::Consumer.new(configatron.youroomn.consumer.key, configatron.youroom.consumer.secret, :site => "#{root_url}")
  end

  def self.root_url
     "http://www.youroom.in"
  end

  def self.my_groups_url
    "https://www.youroom.in/groups/my"
  end

  def self.verify_credentials_url
    "https://www.youroom.in/verify_credentials"
  end
  
  def self.post_url group_id
    "https://www.youroom.in/r/#{group_id}/entries.json"
  end

  def self.message_max_length
    280
  end
end
