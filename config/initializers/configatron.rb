resource = Rails.env.production? ? ENV : Pit.get(
  'attentive.ada',
  :require => {
    'youroom.consumer.key' => '',
    'youroom.consumer.secret' => '',
    'youroom.access_token.key' => '',
    'youroom.access_token.secret' => '',
    'google.consumer.key' => '',
    'google.consumer.secret' => '',
    'google.access_token.key' => '',
    'google.access_token.secret' => '',
    'attentive-ada.timezone' => '',
    'bitly.user_id' => '',
    'bitly.api_key' => ''
  })
configatron.youroom.consumer.key = resource['youroom.consumer.key']
configatron.youroom.consumer.secret = resource['youroom.consumer.secret']
# post by below user to youroom
configatron.youroom.access_token.key = resource['youroom.access_token.key']
configatron.youroom.access_token.secret = resource['youroom.access_token.secret']

configatron.google.consumer.key = resource['google.consumer.key']
configatron.google.consumer.secret = resource['google.consumer.secret']
# post by below user to google
configatron.google.access_token.key = resource['google.access_token.key']
configatron.google.access_token.secret = resource['google.access_token.secret']
configatron.timezone = resource['attentive-ada.timezone']
configatron.bitly.user_id = resource['bitly.user_id']
configatron.bitly.api_key = resource['bitly.api_key']