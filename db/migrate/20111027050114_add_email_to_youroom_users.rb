class AddEmailToYouroomUsers < ActiveRecord::Migration
  def change
    add_column :youroom_users, :email, :string
  end
end
