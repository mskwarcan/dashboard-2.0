class Finished < ActiveRecord::Migration
  def self.up
    add_column :updates, :tweet_done, :boolean, :default => false
    add_column :updates, :face_done, :boolean, :default => false
    add_column :updates, :google_done, :boolean, :default => false
  end

  def self.down
    remove_column :updates, :tweet_done
    remove_column :updates, :face_done
    remove_column :updates, :google_done
  end
end
