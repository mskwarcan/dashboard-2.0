class AccountCreator < ActiveRecord::Migration
  def self.up
    add_column :accounts_users, :creator, :boolean, :default => false
  end

  def self.down
    remove_column :accounts_users, :creator
  end
end
