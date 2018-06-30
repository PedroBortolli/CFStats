class AddUsernameToUserSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :user_settings, :username, :string
  end
end
