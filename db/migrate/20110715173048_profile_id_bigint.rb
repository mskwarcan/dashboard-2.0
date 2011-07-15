class ProfileIdBigint < ActiveRecord::Migration
  def self.up
    remove_column :accounts_users, :status
    add_column :accounts_users, :status, :string, :default => 'pending'
    change_column :accounts_users, :profile_id, :bigint  
    change_column :accounts_users, :access, :string, :default => 'viewer'
  end

  def self.down
    add_column :accounts_users, :status, :integer
    remove_column :accounts_users, :status
    remove_column :accounts_users, :profile_id
    add_column :accounts_users, :profile_id, :integer
  end
end
