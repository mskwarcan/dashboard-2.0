class ChimpChatter < ActiveRecord::Migration
  def self.up
    add_column :updates, :chatter, :text
  end

  def self.down
    remove_column :updates, :chatter
  end
end
