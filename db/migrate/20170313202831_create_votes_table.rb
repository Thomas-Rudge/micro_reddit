class CreateVotesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer "user_id",      null: false, unique: true
      t.integer "subject_type", null: false
      t.integer "subject_id",   null: false
      t.integer "vote",         null: false
    end
  end
end
