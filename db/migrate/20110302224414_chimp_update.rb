class ChimpUpdate < ActiveRecord::Migration
  def self.up
    add_column :updates, :chimp_name, :string
    add_column :updates, :growth, :text
    add_column :updates, :campaign, :text
    add_column :updates, :stats, :text
    add_column :updates, :chimp_done, :boolean, :default => false
  end

  def self.down
    remove_column :updates, :chimp_name
    remove_column :updates, :growth
    remove_column :updates, :campaign
    remove_column :updates, :stats
    remove_column :updates, :chimp_done
  end
end
