class Analytics < ActiveRecord::Migration
  def self.up
    add_column :users, :analytics_authenticated, :boolean, :default => false
    add_column :users, :analytics, :string
  end

  def self.down
    remove_column :users, :analytics_authenticated
    remove_column :users, :analytics
  end
end
