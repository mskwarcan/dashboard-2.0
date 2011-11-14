class Campaigns < ActiveRecord::Migration
  def self.up
    add_column :updates, :stats4, :text
    add_column :updates, :stats5, :text
    add_column :updates, :stats6, :text
    add_column :updates, :stats7, :text
    add_column :updates, :stats8, :text
    add_column :updates, :stats9, :text
    add_column :updates, :stats10, :text
  end

  def self.down
    remove_column :updates, :stats4
    remove_column :updates, :stats5
    remove_column :updates, :stats6
    remove_column :updates, :stats7
    remove_column :updates, :stats8
    remove_column :updates, :stats9
    remove_column :updates, :stats10
  end
end
