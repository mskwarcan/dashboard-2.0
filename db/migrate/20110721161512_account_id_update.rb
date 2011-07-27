class AccountIdUpdate < ActiveRecord::Migration
  def self.up
    add_column :updates, :account_id, :integer
  end

  def self.down
    remove_column :updates, :account_id
  end
end
