class AccountsUsers < ActiveRecord::Migration
    def self.up
      create_table :accounts_users, :id => false do |t|
        t.integer :account_id
        t.integer :user_id
      end
    end

    def self.down
      drop_table :accounts_users
    end
  end