class AddYouroomUserIdToGoogleAccounts < ActiveRecord::Migration
  def change
    add_column :google_accounts, :youroom_user_id, :integer
  end
end
