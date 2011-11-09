url_options= { :host => ENV['host'] }
url_options.merge!(:port => ENV['port']) unless ENV['port'].blank? or ENV['port'] == "80"

configatron.youroom_url_options = url_options
