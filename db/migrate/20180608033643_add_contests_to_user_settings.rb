class AddContestsToUserSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :user_settings, :contests, :string
  end
end
