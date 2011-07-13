class StringToInt < ActiveRecord::Migration
  def self.up
    remove_column :accounts_users, :account_id
    remove_column :accounts_users, :user_id
    add_column :accounts_users, :account_id, :integer
    add_column :accounts_users, :user_id, :integer
  end

  def self.down
    remove_column :accounts_users, :account_id
    remove_column :accounts_users, :user_id
    add_column :accounts_users, :account_id, :string
    add_column :accounts_users, :user_id, :string
  end
end
