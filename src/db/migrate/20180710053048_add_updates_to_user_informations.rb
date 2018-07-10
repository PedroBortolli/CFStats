class AddUpdatesToUserInformations < ActiveRecord::Migration[5.1]
  def change
    add_column :user_informations, :updates, :integer
  end
end
