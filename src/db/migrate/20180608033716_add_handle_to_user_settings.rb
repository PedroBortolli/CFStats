class AddHandleToUserSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :user_settings, :handle, :string
  end
end
