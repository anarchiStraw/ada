class CreateGoogleAccounts < ActiveRecord::Migration
  def change
    create_table :google_accounts do |t|
      t.string :display_name
      t.string :email
      t.string :access_token
      t.string :access_token_secret

      t.timestamps
    end
  end
end
