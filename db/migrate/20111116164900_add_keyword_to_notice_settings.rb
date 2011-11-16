class AddKeywordToNoticeSettings < ActiveRecord::Migration
  def change
    add_column :notice_settings, :keyword, :string
    add_column :notice_settings, :use_keyword, :boolean
  end
end
