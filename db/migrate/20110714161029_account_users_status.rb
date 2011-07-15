class AccountUsersStatus < ActiveRecord::Migration
  def self.up
    add_column :accounts_users, :status, :string, :default => 'pending'
  end

  def self.down
    remove_column :accounts_users, :status
  end
end
