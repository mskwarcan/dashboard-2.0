class DropAccountsUsersId < ActiveRecord::Migration
  def self.up
    remove_column :accounts_users, :id
  end

  def self.down
    remove_column :accounts_users, :id, :integer
  end
end
