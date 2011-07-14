class AccountListsFormat < ActiveRecord::Migration
  def self.up
    remove_column :account_lists, :profile_id
    remove_column :account_lists, :account_id
    add_column :account_lists, :profile_id, :integer
    add_column :account_lists, :account_id, :integer
  end

  def self.down
    add_column :account_lists, :profile_id, :string
    add_column :account_lists, :account_id, :string
    remove_column :account_lists, :profile_id
    remove_column :account_lists, :account_id
  end
end
