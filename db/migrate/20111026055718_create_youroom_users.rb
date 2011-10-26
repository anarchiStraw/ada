class CreateYouroomUsers < ActiveRecord::Migration
  def change
    create_table :youroom_users do |t|
      t.string :access_token
      t.string :access_token_secret

      t.timestamps
    end
  end
end
