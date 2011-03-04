class AdditionalCampaigns < ActiveRecord::Migration
  def self.up
    add_column :updates, :stats2, :text
    add_column :updates, :stats3, :text
    add_column :updates, :top_open, :text
    add_column :updates, :top_click, :text
  end

  def self.down
    remove_column :updates, :stats2 
    remove_column :updates, :stats3 
    remove_column :updates, :top_open
    remove_column :updates, :top_click
  end
end
