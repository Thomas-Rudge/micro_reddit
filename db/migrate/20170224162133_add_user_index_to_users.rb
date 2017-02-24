class AddUserIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :user, unique: true
  end
end
