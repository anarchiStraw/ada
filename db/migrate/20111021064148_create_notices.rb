class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :calender_name
      t.string :calender_url
      t.string :youroom_access_token
      t.string :youroom_access_token_secret
      t.string :room_name
      t.integer :room_id
      t.string :message

      t.timestamps
    end
  end
end
