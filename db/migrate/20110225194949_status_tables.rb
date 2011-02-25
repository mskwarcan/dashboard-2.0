class StatusTables < ActiveRecord::Migration
  def self.up
    create_table :updates do |t|
      t.string :user_id
      t.string :twit_pic
      t.string :twit_name
      t.integer :followers
      t.integer :new_followers
      t.text   :tweets
      t.string :face_pic
      t.string :face_name
      t.integer :likes
      t.integer :new_likes
      t.text :feed
      t.text :results

      t.timestamps
    end
  end

  def self.down
    drop_table :updates
  end
end
