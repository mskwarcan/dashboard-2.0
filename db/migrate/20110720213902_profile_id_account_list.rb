class ProfileIdAccountList < ActiveRecord::Migration
  def self.up
    remove_column :account_lists, :profile_id
    add_column :account_lists, :profile_id, :string
  end

  def self.down
    remove_column :account_lists, :profile_id
    add_column :account_lists, :profile_id, :integer, :limit => 8
  end
end
