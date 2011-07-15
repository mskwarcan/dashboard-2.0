class TwitterName < ActiveRecord::Migration
  def self.up
    add_column :accounts, :twitter_name, :string
    add_column :accounts_users, :access, :string, :default => 'viewer'
  end

  def self.down
    remove_column :accounts, :twitter_name
    remove_column :accounts_users, :access
  end
end
