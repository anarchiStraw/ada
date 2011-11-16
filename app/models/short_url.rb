class ShortUrl
  def self.get(long_url)
    id = configatron.bitly.user_id
    api_key = configatron.bitly.api_key

    query = "?longUrl=#{long_url}&login=#{id}&apiKey=#{api_key}"
    result = JSON.parse(Net::HTTP.get("api.bit.ly", "/v3/shorten#{query}"))
    result['data']['url']
  end
end