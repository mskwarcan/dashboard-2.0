class Bigint < ActiveRecord::Migration
  def self.up
    remove_column :accounts_users, :profile_id
    add_column :accounts_users, :profile_id, :integer, :limit => 8
  end

  def self.down
    remove_column :accounts_users, :profile_id
    add_column :accounts_users, :profile_id, :integer
  end
end
