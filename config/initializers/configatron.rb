pit = Pit.get(
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
    'timezone' => ''
  })
configatron.youroom.consumer.key = pit['youroom.consumer.key']
configatron.youroom.consumer.secret = pit['youroom.consumer.secret']
# post by below user to youroom
configatron.youroom.access_token.key = pit['youroom.access_token.key']
configatron.youroom.access_token.secret = pit['youroom.access_token.secret']

configatron.google.consumer.key = pit['google.consumer.key']
configatron.google.consumer.secret = pit['google.consumer.secret']
# post by below user to google
configatron.google.access_token.key = pit['google.access_token.key']
configatron.google.access_token.secret = pit['google.access_token.secret']
configatron.timezone = pit['timezone']
