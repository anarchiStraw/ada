#coding:utf-8

class NoticeSetting < ActiveRecord::Base
  belongs_to :youroom_user
  belongs_to :google_accounts
  
  @@days_before_options = { '当日' => 0, '前日' => 1, '2日前' => 2 }
  def self.days_before_options
    return @@days_before_options
  end
  
  def after_initialize
    self[:days_before] = 0
    self[:additional_message] = '【もうすぐです】'
    # TODO 初期値設定方法、、、ActiveRecordの。
  end

end
