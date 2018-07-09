class CreateUserInformations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_informations do |t|
      t.string :handle
      t.string :info

      t.timestamps
    end
  end
end