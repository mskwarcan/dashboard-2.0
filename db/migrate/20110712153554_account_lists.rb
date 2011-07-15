class AccountLists < ActiveRecord::Migration
  def self.up
      create_table :account_lists do |t|
        t.integer :account_id
        t.integer :profile_id, :limit => 8
        t.string :profile_name
        t.string :profile_type

        t.timestamps
      end
  end

  def self.down
    drop_table :account_lists
  end
end
