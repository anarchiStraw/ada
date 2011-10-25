pit = Pit.get(
  'attentive.ada',
  :require => {
    'youroom.consumer.key' => '',
    'youroom.consumer.secret' => '',
    'youroom.access_token.key' => '',
    'youroom.access_token.secret' => ''
  })
configatron.youroom.consumer.key = pit['youroom.consumer.key']
configatron.youroom.consumer.secret = pit['youroom.consumer.secret']
# post by below user to youroom
configatron.youroom.access_token.key = pit['youroom.access_token.key']
configatron.youroom.access_token.secret = pit['youroom.access_token.secret']