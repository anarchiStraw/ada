class CreateNoticeSettings < ActiveRecord::Migration
  def change
    create_table :notice_settings do |t|
      t.integer :youroom_user_id
      t.integer :room_number
      t.string :room_name
      t.integer :google_account_id
      t.string :google_calendar_id
      t.string :google_calendar_name
      t.integer :days_before
      t.string :additional_message

      t.timestamps
    end
  end
end
