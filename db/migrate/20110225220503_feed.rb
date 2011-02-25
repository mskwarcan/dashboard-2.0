class Feed < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :feed_id
      t.string :picture
      t.string :link
    end
  end

  def self.down
    drop_table :feeds
  end
end
