class AccountsUsers < ActiveRecord::Migration
    def self.up
      create_table :accounts_users do |t|
        t.string :account_id
        t.string :user_id
      end
    end

    def self.down
      drop_table :accounts_users
    end
  end