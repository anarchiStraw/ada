class Youroom
  def self.root_url
     "http://youroom.in"
#    "http://#{configatron.youroom_url_options[:host]}:#{configatron.youroom_url_options[:port]}"
  end

  def self.group_url group_id
    "#{scheme}://www.#{configatron.youroom_url_options[:host]}:#{configatron.youroom_url_options[:port]}/r/#{group_id}"
  end

  def self.my_groups_url
    "#{scheme}://www.#{configatron.youroom_url_options[:host]}:#{configatron.youroom_url_options[:port]}/groups/my"
  end

  def self.scheme
    if %w(production staging).include? ::Rails.env
      "https"
    else
      "http"
    end
  end
end
