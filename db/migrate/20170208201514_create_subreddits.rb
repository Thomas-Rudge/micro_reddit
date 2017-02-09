class CreateSubreddits < ActiveRecord::Migration[5.0]
  def change
    create_table :subreddits do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :nsfw

      t.timestamps

      t.index :name, unique: true
    end
  end
end
