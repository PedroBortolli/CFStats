class AddFriendsToUserSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :user_settings, :friends, :string
  end
end
