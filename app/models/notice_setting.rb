#coding:utf-8

class NoticeSetting < ActiveRecord::Base
  belongs_to :youroom_user
  belongs_to :google_accounts

  validates :room_number,
    :presence => true
  validates :google_calendar_id,
    :presence => true,
    :uniqueness => { :scope => :room_number, :message => " このルームへは、同じカレンダーからの通知設定がもうあります。" }
  
  @@days_before_options = { '当日' => 0, '前日' => 1, '2日前' => 2 }
  def self.days_before_options
    return @@days_before_options
  end
  
  def warnings
    read_attribute(:warnings)
  end
  
  def warnings=(v)
    write_attribute(:warnings, v)
  end
  
  def google_account
    read_attribute(:google_account)
  end

  def google_account=(v)
    write_attribute(:google_account, v)
  end
  
end
